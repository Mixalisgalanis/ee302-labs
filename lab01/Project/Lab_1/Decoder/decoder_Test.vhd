--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:14:53 02/20/2019
-- Design Name:   
-- Module Name:   H:/xilinx/Lab_1/Decoder/decoder_Test.vhd
-- Project Name:  Lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decoder5To32
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY decoder_Test IS
END decoder_Test;
 
ARCHITECTURE behavior OF decoder_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder5To32
    PORT(
         Awr : IN  std_logic_vector(4 downto 0);
         decAdr : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal decAdr : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder5To32 PORT MAP (
          Awr => Awr,
          decAdr => decAdr
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		Awr <= "00000";
		wait for 25 ns;	
		Awr <= "00001";
		wait for 25 ns;	
		Awr <= "01000";
		wait for 25 ns;	
		Awr <= "11111";
		wait for 25 ns;	
		Awr <= "00111";
		
 

      -- insert stimulus here 

      wait;
   end process;

END;
