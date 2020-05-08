--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:54:09 02/16/2019
-- Design Name:   
-- Module Name:   H:/xilinx/Lab_1/Test_A.vhd
-- Project Name:  Lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: part_A
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

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_A IS
END Test_A;
 
ARCHITECTURE behavior OF Test_A IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT part_A
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: part_A PORT MAP (
          A => A,
          B => B,
          Op => Op,
          Output => Output,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
     wait for 50 ns;
		-------------------
		
		
		--   ADD__SUB 
		A <= "01111000000000000000000000000000";
		B <= "00111000000000000000000000000000";
		Op <= "0000";
		wait for 50  ns;	
			Op <= Op +1;
		wait for 50 ns;	
		
		--   ADD__SUB
		A <= "11110000000000000000000000000000";
		B <= "11100000000000000000000000000000";
		Op <= "0000";
		wait for 50  ns;	
			Op <= Op +1;
		wait for 50  ns;	
		
		--   ADD__SUB__AND__OR__NOT
		A <= "10000000000000000000000000000000";
		B <= "11111111111111111111111111111111";
		Op <= "0000";
		wait for 50  ns;	
		for i in 1 to 3 loop
			Op <= Op +1;
			wait for 50 ns;	
		end loop;
		-- SHIFT_RIGHT ____ SHIFT_LEFT
		A <= "10000000000000000000000000000001";		
		Op <= "1000";
		wait for 50 ns;
		for i in 1 to 2 loop
			Op <= Op +1;
			wait for 50 ns;	
		end loop;
		
		-- ROTATE
		A <= "00011010101010101010101010100011";
		Op <= "1100";
		wait for 50 ns;
		for i in 1 to 2 loop
			Op <= Op +1;
			wait for 50 ns;	
		end loop;
      wait;
   end process;

END;
