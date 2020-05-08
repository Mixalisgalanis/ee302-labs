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
	X <= x"00000400" + STD_LOGIC_VECTOR(signed(A));
end Behavioral;