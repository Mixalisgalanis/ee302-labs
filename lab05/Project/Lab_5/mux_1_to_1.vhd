----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:56:27 04/14/2019 
-- Design Name: 
-- Module Name:    decoder_2TO1 - Behavioral 
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

entity mux_1_1 is
    Port ( zero : in  STD_LOGIC;
           branch : in  STD_LOGIC_VECTOR (1 downto 0);
           zero_out : out  STD_LOGIC);
end mux_1_1;

architecture Behavioral of mux_1_1 is

begin
	p_mux : process(zero,branch)
	begin
	  case branch is
		 when "00" => zero_out <= '1' ;
		 when "01" => zero_out <= zero ;
		 when "10" => zero_out <= not zero ;
		 when others => zero_out <= '1' ;
	  end case;
	end process p_mux;


end Behavioral;

