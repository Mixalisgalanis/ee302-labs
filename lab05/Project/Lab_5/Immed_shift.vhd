
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;

entity Immed_shift is
    Port ( 	immed : in  STD_LOGIC_VECTOR (31 downto 0);
				shif_imm : out  STD_LOGIC_VECTOR (31 downto 0));
end Immed_shift;

architecture Behavioral of Immed_shift is

begin
im32out: process(immed)
	begin
		shif_imm <= STD_LOGIC_VECTOR(shift_left(signed(immed),2));
	end process;

end Behavioral;

