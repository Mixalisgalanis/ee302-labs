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
			  MemWr : out STD_LOGIC;
			  shift :out std_logic
          );
end CONTROL;

architecture Behavioral of CONTROL is

begin

end Behavioral;


