
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity decoder5To32 is
    Port ( Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           decAdr : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder5To32;

architecture Behavioral of decoder5To32 is
begin
	process(Awr)
	begin
		-- we set the n bit of the output '1' and the rest of them '0'. n is the decimal format of the 5bit awr 
		decAdr <= (others => '0') ;
		decAdr( to_integer(unsigned(Awr))) <='1' after 5 ns ;	
	end process;
end Behavioral;

