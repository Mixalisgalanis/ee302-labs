----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:06:30 03/19/2019 
-- Design Name: 
-- Module Name:    Top_module - Behavioral 
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

entity Top_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Top_module;

architecture Behavioral of Top_module is

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

component processor is
    Port( 
			clk : in  STD_LOGIC;
         reset : in  STD_LOGIC; 
			inst_addr : out std_logic_vector(10 downto 0);         
			inst_dout : in std_logic_vector(31 downto 0);         
			data_we     : out std_logic;         
			data_addr     : out std_logic_vector(10 downto 0);         
			data_din     : out std_logic_vector(31 downto 0);         
			data_dout  : in std_logic_vector(31 downto 0));     
end component;

signal s_instructions : std_logic_vector(31 downto 0);
signal s_inst_addr :  std_logic_vector(10 downto 0); 
signal s_data_addr :  std_logic_vector(10 downto 0); 
signal s_data_out :  std_logic_vector(31 downto 0);
signal s_data_din :  std_logic_vector(31 downto 0);
signal s_MemWr : std_logic;

begin

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
				
PROC :processor
	PORT MAP(   
				clk       => clk,    
				reset		 => reset,
				inst_addr => s_inst_addr,            
				inst_dout => s_instructions,         
				data_we   => s_MemWr,    
				data_addr => s_data_addr,        
				data_din  => s_data_din,        
				data_dout => s_data_out
				);

end Behavioral;

