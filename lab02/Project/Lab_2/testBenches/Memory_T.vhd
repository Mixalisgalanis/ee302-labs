----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:46 03/06/2019 
-- Design Name: 
-- Module Name:    Memory_T - Behavioral 
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

entity Memory_T is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  data_we : in std_logic;
			  CU_PC_sel : in std_logic;
			  CU_PC_LdEn : in std_logic;
			  s_ALU_out : in std_logic_vector(31 downto 0);
			  s_data_din : in std_logic_vector(31 downto 0);
			  data_dout : out std_logic_vector(31 downto 0)
			  );
end Memory_T;

architecture Behavioral of Memory_T is



component RAM is 
	port (         
			clk     : in std_logic;         
			inst_addr : in std_logic_vector(10 downto 0);         
			inst_dout : out std_logic_vector(31 downto 0);         
			data_we     : in std_logic;         
			data_addr     : in std_logic_vector(10 downto 0);         
			data_din     : in std_logic_vector(31 downto 0);         
			data_dout  : out std_logic_vector(31 downto 0)
			);     
end component;   


--------------------------- IFSTAGE (PROGRAMM COUNTER) --------------------------------
component IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MEMSTAGE is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_MEM_NewAddr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal s_instructions : std_logic_vector(31 downto 0);
signal s_inst_addr :  std_logic_vector(31 downto 0); 
signal s_data_addr :  std_logic_vector(31 downto 0); 
signal s_data_out :  std_logic_vector(31 downto 0);


begin

RM :RAM  
	PORT MAP(         
				clk       => clk,    
				inst_addr => s_inst_addr(12 downto 2),            
				inst_dout => s_instructions,         
				data_we   => data_we,    
				data_addr => s_data_addr(12 downto 2),        
				data_din  => s_data_din,        
				data_dout => data_dout
				);     
				

--Inst Memory
IN_FETCH : IFSTAGE 
   PORT MAP( 
				PC_Immed => "01010101010101010101010101010101",
				PC_sel   => CU_PC_sel,
				PC_LdEn  => CU_PC_LdEn,
				Reset    => reset,   
				Clk 		=> clk,
				PC 		=> s_inst_addr 
			  );
--Data Memory  
MEM: MEMSTAGE 
   PORT MAP( 
				ALU_MEM_Addr 	 => s_ALU_out,
				ALU_MEM_NewAddr => s_data_addr       
				);

end Behavioral;

