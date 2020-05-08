----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:40 03/06/2019 
-- Design Name: 
-- Module Name:    processor - Behavioral 
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

entity processor is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  out1: out std_logic;
			  out2: out std_logic
			  );
end processor;

architecture Behavioral of processor is

component CONTROL is
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
			  MemWr : out STD_LOGIC;
			  shift :out std_logic
          );
end component;

component Datapath is
    Port( 
			clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			--Memory input signals 
			instructions : in std_logic_vector(31 downto 0);  
			instr_address :out std_logic_vector(10 downto 0);
			data_dout : in std_logic_vector(31 downto 0);  
			data_addr : out std_logic_vector(10 downto 0); 
			data_din  : out std_logic_vector(31 downto 0); 
			--contol unit signals
			CU_ALUctr : in std_logic_vector(3 downto 0);
			CU_ALUSrc : in STD_LOGIC;
			CU_RF_WrEn : in STD_LOGIC;
			CU_MemtoReg : in STD_LOGIC;
			CU_PC_LdEn : in STD_LOGIC;
			CU_PC_sel : in STD_LOGIC;
			CU_RF_B_sel : in STD_LOGIC;
			CU_Exten : in STD_LOGIC;
			CU_shift : in STD_LOGIC;
			zero :out STD_LOGIC		
		  );
end component;



component RAM is 
	port (         
			clk     : in std_logic;         
			inst_addr : in std_logic_vector(10 downto 0);         
			inst_dout : out std_logic_vector(31 downto 0);         
			data_we     : in std_logic;         
			data_addr     : in std_logic_vector(10 downto 0);         
			data_din     : in std_logic_vector(31 downto 0);         
			data_dout  : out std_logic_vector(31 downto 0));     
end component;   


signal s_instructions : std_logic_vector(31 downto 0);
signal s_inst_addr :  std_logic_vector(10 downto 0); 
signal s_data_addr :  std_logic_vector(10 downto 0); 
signal s_data_out :  std_logic_vector(31 downto 0);
signal s_data_din :  std_logic_vector(31 downto 0);
signal s_zero : std_logic;
signal s_ALUctr : std_logic_vector(3 downto 0);
signal s_ALUsrc : std_logic;
signal s_extop : std_logic;
signal s_MemToReg : std_logic;
signal s_Rb_RF_sel : std_logic;
signal s_PC_LdEn : std_logic;
signal s_PC_sel : std_logic;
signal s_RF_WrEn : std_logic;
signal s_MemWr : std_logic;
signal s_shift : std_logic;

begin

DTPATH: Datapath 
   PORT MAP( 
				clk   => clk,
				reset => reset,
				--Memory input signals 
				instructions => s_instructions, 
				instr_address => s_inst_addr,
				data_dout => s_data_out,  
				data_addr => s_data_addr,
				data_din  => s_data_din,
				--contol unit signals
				CU_ALUctr => s_ALUctr,
				CU_ALUSrc => s_ALUsrc,
				CU_RF_WrEn => s_RF_WrEn,
				CU_MemtoReg => s_MemToReg,
				CU_PC_LdEn => s_PC_LdEn,
				CU_PC_sel => s_PC_sel,
				CU_RF_B_sel => s_Rb_RF_sel,
				CU_Exten => s_extop,
				CU_shift => s_shift,
				zero => s_zero
				);


RM :RAM  
	PORT MAP(         
				clk       => clk,    
				inst_addr => s_inst_addr,            
				inst_dout => s_instructions,         
				data_we   => s_MemWr,    
				data_addr => s_data_addr,        
				data_din  => s_data_din,        
				data_dout => s_data_out
				);
				
CNTRL:  CONTROL 
   PORT MAP( 
				instructions =>  s_instructions,
				zero => s_zero,
				clk => clk,
				reset => reset,
				ALUctr => s_ALUctr,
				ALUsrc => s_ALUsrc,
				Extop => s_extop,
				MemToReg => s_MemToReg,
				Rb_RF_sel => s_Rb_RF_sel,
				PC_LdEn =>	s_PC_LdEn,
				PC_sel =>	s_PC_sel,
				RF_WrEn =>	s_RF_WrEn,
				MemWr =>	s_MemWr,
				shift => s_shift
			  );
out1 <=s_ALUsrc;
out2 <=s_zero;
end Behavioral;

