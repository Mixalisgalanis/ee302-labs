
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX64TO32 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX64TO32;

architecture Behavioral of MUX64TO32 is

begin
	process(A,B,SEL)
	begin
		if SEL = '0' then X <= A;
		else X <= B;
		end if;
	end process;
end Behavioral;

