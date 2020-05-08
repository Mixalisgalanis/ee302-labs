library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_STD.ALL;

entity Incrementor is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end Incrementor;

architecture Behavioral of Incrementor is

begin
	X <= STD_LOGIC_VECTOR(signed(A) + 4);
end Behavioral;

