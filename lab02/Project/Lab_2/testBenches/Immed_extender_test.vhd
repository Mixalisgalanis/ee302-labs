--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:39:42 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/zzhar/Desktop/LAB_2_con/Lab_2/testBenches/Immed_extender_test.vhd
-- Project Name:  Lab_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Immed_extender
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
 
ENTITY Immed_extender_test IS
END Immed_extender_test;
 
ARCHITECTURE behavior OF Immed_extender_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Immed_extender
    PORT(
         imm16 : IN  std_logic_vector(15 downto 0);
         extension : IN  std_logic;
         shifting : IN  std_logic;
         imm32 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal imm16 : std_logic_vector(15 downto 0) := (others => '0');
   signal extension : std_logic := '0';
   signal shifting : std_logic := '0';

 	--Outputs
   signal imm32 : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Immed_extender PORT MAP (
          imm16 => imm16,
          extension => extension,
          shifting => shifting,
          imm32 => imm32
        );



   -- Stimulus process
   stim_proc: process
   begin	
	
			imm16 <= "1100000100010001";	
			extension <='1';
			shifting <='1';
      wait for 100 ns;
			imm16 <= "1100000100010001";	
			extension <='0';
			shifting <='1';
		wait for 100 ns;
			imm16 <= "1100000100010001";	
			extension <='1';
			shifting <='0';
		wait for 100 ns;
			imm16 <= "1100000100010001";	
			extension <='0';
			shifting <='0';
      wait;
   end process;

END;
