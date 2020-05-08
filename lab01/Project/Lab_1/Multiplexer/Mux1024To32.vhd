
library ieee;
use ieee.std_logic_1164.all;

package dt_array_pkg is
        type dt_array is array(31 downtO 0) of std_logic_vector(31 downtO 0);
end package;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use work.dt_array_pkg.all;

entity Mux1024To32 is
   Port ( Reg : in dt_array ;
          muxAdr : in  STD_LOGIC_VECTOR (4 downto 0);
          Dout : out  STD_LOGIC_VECTOR (31 downto 0)
			 );
end Mux1024To32;

architecture Behavioral of Mux1024To32 is


begin
	process(muxAdr, Reg)
	begin
		-- we set as dout the n register from the input array. n is the decimal format of the 5bit muxAdr(0-31__00000-11111) 
		Dout <= Reg(to_integer(unsigned(muxAdr))) after 5 ns;
	end process;
end Behavioral;