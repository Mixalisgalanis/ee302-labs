----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:12:30 02/16/2019 
-- Design Name: 
-- Module Name:    regi - Behavioral 
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end regi;

architecture Behavioral of regi is

begin

output: process(clk,reset)
begin 
	if reset='1' then 
		Dout <= (others =>'0');
	elsif rising_edge(clk) then 
		if WE ='1' then		
			Dout <= Data after 5ns ;
		end if;
	end if;
end process;

end Behavioral;
