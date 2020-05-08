----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:55:38 03/06/2019 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL is
    Port ( instructions : in  STD_LOGIC_VECTOR (31 downto 0);
			  zero : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ALUctr : out  STD_LOGIC_VECTOR(3 downto 0);
           ALUsrc : out  STD_LOGIC;
           Extop : out  STD_LOGIC;
           MemToReg : out  STD_LOGIC;
           Rb_RF_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC;
           PC_sel : out  STD_LOGIC;
           RF_WrEn : out  STD_LOGIC;
			  ByteEnable : out STD_LOGIC;
			  MemWr : out STD_LOGIC;
			  shift :out std_logic;
			  shift16: out std_logic
          );
end CONTROL;

architecture Behavioral of CONTROL is


signal li, lui, addi, nandi, ori, b, beq, bne, lb, sb,lw,sw,Rtype: std_logic ;
signal opcode: std_logic_vector(5 downto 0);
signal imm16 :std_logic_vector(15 downto 0);
begin

imm16 <= instructions(15 downto 0);


commands: process(instructions(31 downto 26),opcode )
	begin 
		opcode <= instructions(31 downto 26);
		 
		Rtype <= 	  opcode(5)	 and(not opcode(4));
		li    <=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)	 and (not opcode(2))and (not opcode(1))and (not opcode(0)); 			--(111000)
		lui	<=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)  and (not opcode(2))and (not opcode(1))and      opcode(0) ;				--(111001)
		addi	<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and (not opcode(0));				--(110000)
		nandi	<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and      opcode(1) and (not opcode(0));				--(110010)
		ori	<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and      opcode(1) and      opcode(0) ;				--(110011)
		b		<=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)	 and      opcode(2) and      opcode(1) and      opcode(0) ;				--(111111)
		beq	<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and (not opcode(0));				--(000000)
		bne	<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and      opcode(0) ;				--(000001)
		lb		<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and      opcode(1) and      opcode(0) ;				--(000011)
		sb		<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and      opcode(2) and      opcode(1) and      opcode(0) ;				--(000111)
		lw		<=	(not opcode(5)) and(not opcode(4))	and	  opcode(3)  and      opcode(2) and      opcode(1) and      opcode(0) ;				--(001111)
		sw		<= (not opcode(5)) and	  opcode(4) 	and	  opcode(3)  and      opcode(2) and      opcode(1) and      opcode(0) ;				--(011111)
end process;

byte_enable : process(opcode,lb, sb)
begin
	ByteEnable <= lb or sb;
end process;


-----------------------------------------------------------------------------------------

ext_sh: process(li, lui, addi, nandi, ori, b, beq, bne, lb, sb,lw,sw)
	begin
		Extop <= (li or addi or b or beq or bne or lb or sb or lw or sw);
		shift <= b or bne or beq;
	end process;
	
-----------------------------------------------------------------------------------------

PC_selector: process(zero, b, beq, bne)
	begin 
		PC_sel<= b or  ( ( zero and beq) or ((not zero) and bne));
	end process;

-----------------------------------------------------------------------------------------

shift16_out : process(lui)
	begin 
		shift16<= lui;
	end process;
	
-----------------------------------------------------------------------------------------		

MWr : process(sb,sw)
	begin  
		MemWr <= sw or sb;
	end process;
	
-----------------------------------------------------------------------------------------

RF_Wr : process(b,beq,bne,sb,sw,Rtype)
	begin
		RF_WrEn <= li or lui or addi or nandi or ori or lb or lw or Rtype;
	end process;

-----------------------------------------------------------------------------------------

RF_Bin: process(beq,bne,sb,sw)
	begin       -- '1'=rd
		Rb_RF_sel  <= beq or bne or sb or sw;
	end process;

-----------------------------------------------------------------------------------------
	
--PC_Load

PC_LdEn <= '1';
-----------------------------------------------------------------------------------------

Mem_RG: process(lb,lw)
	begin
		MemToReg <= lb or lw;
	end process;	

-----------------------------------------------------------------------------------------

ALU_source: process(addi, nandi, ori, sb, lb, lw, sw, li, lui)
	begin		--   1=immmed
		ALUsrc <= li or lui or addi or nandi or ori or lb or sb or lw or sw;
	end process;
	
-----------------------------------------------------------------------------------------

ALU_control:process(instructions(3 downto 0),li, lui, addi, nandi, ori, b, beq, bne, lb, sb,lw,sw,Rtype)
	begin
		if (Rtype ='1') then
			ALUctr <= instructions(3 downto 0);
		elsif ((sw or lw or sb or lb or addi)='1') then
			ALUctr <= "0000";
		elsif ((bne or beq)='1' ) then 
			ALUctr <= "0001";
		elsif ((ori or nandi) = '1') then 
			ALUctr <= instructions(29 downto 26) ;
		else 
			ALUctr <= "1111";
		end if;
	end process;
       
		

end Behavioral;


