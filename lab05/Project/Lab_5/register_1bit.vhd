----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:36 04/14/2019 
-- Design Name: 
-- Module Name:    register_1bit - Behavioral 
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

entity register_1bit is
    Port ( clk : in  STD_LOGIC;
           data : in  STD_LOGIC;
           dout : out  STD_LOGIC;
           we : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end register_1bit;

architecture Behavioral of register_1bit is

begin
	output: process(clk,reset)
	begin 
		if reset='1' then 
			Dout <= '0';
		elsif rising_edge(clk) then 
			if WE ='1' then		
				Dout <= Data after 5ns ;
			end if;
		end if;
	end process;

end Behavioral;

