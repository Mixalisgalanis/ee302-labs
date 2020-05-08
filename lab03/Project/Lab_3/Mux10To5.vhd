library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux10To5 is
    Port ( Mux_in_A : in  STD_LOGIC_VECTOR (4 downto 0);
           Mux_in_B : in  STD_LOGIC_VECTOR (4 downto 0);
           Mux_sel  : in  STD_LOGIC;
           Mux_out : out  STD_LOGIC_VECTOR (4 downto 0));
end Mux10To5;

architecture Behavioral of Mux10To5 is

begin
	process(Mux_sel,Mux_in_A,Mux_in_B)
	begin
		if Mux_sel = '0' then Mux_out <= Mux_in_A;
		else Mux_out <= Mux_in_B;
		end if;
	end process;
end Behavioral;

