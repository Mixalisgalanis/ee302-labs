--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:22:46 02/20/2019
-- Design Name:   
-- Module Name:   H:/xilinx/Lab_1/Multiplexer/Multiplexer_test.vhd
-- Project Name:  Lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Mux1024To32
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use work.dt_array_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Multiplexer_test IS
END Multiplexer_test;
 
ARCHITECTURE behavior OF Multiplexer_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Mux1024To32
    PORT(
         Reg : in dt_array ;
         muxAdr : IN  std_logic_vector(4 downto 0);
         Dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Reg : dt_array ;
   signal muxAdr : std_logic_vector(4 downto 0);

 	--Outputs
   signal Dout : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Mux1024To32 PORT MAP (
          Reg => Reg,
          muxAdr => muxAdr,
          Dout => Dout
        );

   -- Stimulus process
   stim_proc: process
   begin		
     -- hold reset state for 100 ns.
		Reg(0)<= "00000000000000000000000000000000";
		for i in 1 to 31 loop
			 Reg(i)<= "00000000000000000000000000000000"+i;
		end loop;
		wait for 100 ns;
		muxAdr <= "00000";
		wait for 100 ns;
		muxAdr <= "01000";
		wait for 100 ns;
		muxAdr <= "00100";
		wait for 100 ns;
      -- insert stimulus here 


      -- insert stimulus here 


      wait;
   end process;

END;
