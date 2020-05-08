library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_64_TO_32 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX_64_TO_32;

architecture Behavioral of MUX_64_TO_32 is
begin	
	process(A,B,SEL)
	begin
		if SEL = '0' then X <= A after 5 ns;
		else X <= B after 5 ns;
		end if;
	end process;
end Behavioral;