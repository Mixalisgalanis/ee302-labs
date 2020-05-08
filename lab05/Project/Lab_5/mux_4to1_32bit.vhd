library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_4to1_32bit is
	 Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0); 
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  D : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR(1 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end mux_4to1_32bit;

architecture Behavioral of mux_4to1_32bit is

begin
	process(A,B,C,D,SEL)
	begin
		if 	SEL = "00" then 
			X <= A after 5 ns;
		elsif SEL = "01" then
			X <= B after 5 ns;
		elsif SEL = "10" then
			X <= C after 5 ns;
		elsif SEL = "11" then
			X <= D after 5 ns;
		else	
			X <= A after 5 ns;
		end if;
	end process;

end Behavioral;
