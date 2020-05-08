----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:10:23 02/19/2019 
-- Design Name: 
-- Module Name:    register_file - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package dt_array_pkg is
        type dt_array is array(31 downtO 0) of std_logic_vector(31 downtO 0);
end package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dt_array_pkg.all;


entity register_file is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end register_file;



architecture Structural of register_file is

------------------------------------------------- COMPONENTS ---------------------------------------------------

Component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset : in  STD_LOGIC);
end Component;

Component Mux1024To32 is
   Port ( Reg : in  dt_array ;
          muxAdr : in  STD_LOGIC_VECTOR (4 downto 0);
          Dout : out  STD_LOGIC_VECTOR (31 downto 0)
			 );
end Component;

Component decoder5To32 is
    Port ( Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           decAdr : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end Component;


------------------------------------------------- SIGNALS -------------------------------------------------------
signal register_dout: dt_array ;
signal dec_enbl : STD_LOGIC_VECTOR (31 downto 0);
signal reg_enbl : STD_LOGIC_VECTOR (31 downto 0);
begin

-- The decoder for selecting the register we will write the din (input)
Decoder: decoder5To32
	Port map(	
				Awr 	 => Awr,
				decAdr => dec_enbl
				);
-- Here we generate the "and" gate for each register's we signal with 2 ns delay
reg_enbl(0) <= '0';

WRENABLES: for i in 1 to 31 generate
	reg_enbl(i) <=	WrEn and dec_enbl(i) after 2 ns;
end generate ;

-- Generate 32 registers 
RR: for i in 0 to 31 generate
	Registers: regi 
		PORT MAP ( 	clk 	=> Clk,
						Data 	=> Din,
						Dout 	=> register_dout(i),
						WE		=> reg_enbl(i),
						reset => reset
						);
end generate ;

-- The multiplexer for the first output of register file
MUX_1: Mux1024To32 
	PORT MAP ( 	
					Reg 	 => register_dout,
					muxAdr => Ard1,
					Dout 	 => Dout1
					);
-- The multiplexer for the second output of register file				
MUX_2: Mux1024To32 
	PORT MAP ( 	
					Reg 	 => register_dout,
					muxAdr => Ard2,
					Dout 	 => Dout2
					);
end Structural;