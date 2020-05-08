library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_STD.ALL;

entity AddressIncrementor is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end AddressIncrementor;

architecture Behavioral of AddressIncrementor is
begin
	X <= "00000000000000000000010000000000" + STD_LOGIC_VECTOR(unsigned(A));
end Behavioral;