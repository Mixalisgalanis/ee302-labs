----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:23:54 04/14/2019 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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

entity EX_MEM_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           we : in  STD_LOGIC;
			  pc_in: in STD_LOGIC_VECTOR (31 downto 0);
			  pc_out:out STD_LOGIC_VECTOR (31 downto 0);
			  zero_in:in STD_LOGIC;
			  zero_out:out STD_LOGIC;
			  ALU_out_in:in STD_LOGIC_VECTOR (31 downto 0);
			  ALU_out_out:out STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_in:in STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_out:out STD_LOGIC_VECTOR (31 downto 0);
			  reg_dst_in:in STD_LOGIC_VECTOR (4 downto 0);
			  reg_dst_out:out STD_LOGIC_VECTOR (4 downto 0);
			  EX_MEM_SIG_IN : in STD_LOGIC_VECTOR(4 downto 0);
			  pc_sel_out: out std_logic;
			  branch_out: out std_logic_vector(1 downto 0);
			  bt_EN_out: out std_logic;
			  mem_we_out: out std_logic;
			  MEM_WB_SIG_IN : in STD_LOGIC_VECTOR(1 downto 0);
			  MEM_WB_SIG_OUT : out STD_LOGIC_VECTOR(1 downto 0)
			  );
end EX_MEM_pipeline;

architecture Behavioral of EX_MEM_pipeline is

component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component ;

component  register_1bit is
    Port ( clk : in  STD_LOGIC;
           data : in  STD_LOGIC;
           dout : out  STD_LOGIC;
           we : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component ;


signal s_addr_dout: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_in: STD_LOGIC_VECTOR(31 downto 0);

signal s_EX_MEM_SIG_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_EX_MEM_SIG_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_in: STD_LOGIC_VECTOR(31 downto 0);
begin




-------------------EX_MEM_SIG-----------------------	
					
s_EX_MEM_SIG_in(31 downto 5)<= (others=>'0');
s_EX_MEM_SIG_in(4 downto 0)<= EX_MEM_SIG_IN;
						
EX_MEM_SIG: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_EX_MEM_SIG_in,
						Dout 	=> s_EX_MEM_SIG_out,
						WE		=> we,
						reset => reset
						);
pc_sel_out 	<=s_EX_MEM_SIG_out(0);
branch_out 	<=s_EX_MEM_SIG_out(2 downto 1);
bt_EN_out 	<=s_EX_MEM_SIG_out(3);
mem_we_out 	<=s_EX_MEM_SIG_out(4);	


------------------MEM_WB_SIG---------------------	
					
s_MEM_WB_SIG_in(31 downto 2)<= (others=>'0');
s_MEM_WB_SIG_in(1 downto 0)<= MEM_WB_SIG_IN;
						
MEM_WB_SIG: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_MEM_WB_SIG_in,
						Dout 	=> s_MEM_WB_SIG_out,
						WE		=> we,
						reset => reset
						);
MEM_WB_SIG_OUT<=s_MEM_WB_SIG_out(1 downto 0);



-------------------------- mapping for datapath signals--------------------------------

PC_pls4:	regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> pc_in,
						Dout 	=> pc_out,
						WE		=> we,
						reset => reset
						);
						
zero: register_1bit 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> zero_in,
						Dout 	=> zero_out,
						WE		=> we,
						reset => reset
						);

ALU_out: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> ALU_out_in,
						Dout 	=> ALU_out_out,
						WE		=> we,
						reset => reset
						);

RF_B: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> RF_B_in,
						Dout 	=> RF_B_out,
						WE		=> we,
						reset => reset
						);
						
----------------------------------------------------							
s_addr_in(31 downto 5)<= (others=>'0');
s_addr_in(4 downto 0)<= reg_dst_in;
						
reg_dst: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_addr_in,
						Dout 	=> s_addr_dout,
						WE		=> we,
						reset => reset
						);
						
reg_dst_out<=s_addr_dout(4 downto 0);
----------------------------------------------------
		
end Behavioral;

