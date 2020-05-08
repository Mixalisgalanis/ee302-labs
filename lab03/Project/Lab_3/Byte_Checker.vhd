library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Byte_Checker is
    Port ( MEM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           BYTE_ENABLE : in  STD_LOGIC;
           BYTE_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end Byte_Checker;

architecture Behavioral of Byte_Checker is

begin

	process (MEM_DATA, BYTE_ENABLE)
	begin
		if BYTE_ENABLE = '1' then
				BYTE_DATA(31 downto 8) <= (31 downto 8 => '0');
				BYTE_DATA (7 downto 0) <= MEM_DATA(7 downto 0);
		else
			BYTE_DATA <= MEM_DATA;
		end if;
	end process;
end Behavioral;

