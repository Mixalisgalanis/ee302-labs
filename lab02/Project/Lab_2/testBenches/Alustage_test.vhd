--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:52:54 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/zzhar/Desktop/LAB_2_con/Lab_2/testBenches/Alustage_test.vhd
-- Project Name:  Lab_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALUSTAGE
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
 
ENTITY Alustage_test IS
END Alustage_test;
 
ARCHITECTURE behavior OF Alustage_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALUSTAGE
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALUSrc : IN  std_logic;
         ALUctr : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal ALUSrc : std_logic := '0';
   signal ALUctr : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal zero : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALUSTAGE PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALUSrc => ALUSrc,
          ALUctr => ALUctr,
          ALU_out => ALU_out,
          zero => zero
        );

   
 

   -- Stimulus process
   stim_proc: process
   begin		
       wait for 50 ns;
		-------------------
		
		
		--   ADD__SUB 
		RF_A  <= "01111000000000000000000000000000";
		RF_B  <= "00111000000000000000000000000000";
		Immed <= "10101010101010101010101010101010";
		ALUSrc <= '0';
		ALUctr <= "0000";
		wait for 50  ns;	
		
		
		--   ADD__SUB
		RF_A<= "11110000000000000000000000000000";
		RF_B <= "11100000000000000000000000000000";
		ALUSrc <= '1';
		ALUctr <= "0000";
		wait for 50  ns;	
			ALUctr <= ALUctr +1;
		wait for 50  ns;	
		
		--   ADD__SUB__AND__OR__NOT
		RF_A<= "10000000000000000000000000000000";
		RF_B <= "11111111111111111111111111111111";
		ALUctr <= "0000";
		wait for 50  ns;	
		for i in 1 to 3 loop
			ALUctr <= ALUctr +1;
			wait for 50 ns;	
		end loop;
		-- SHIFT_RIGHT ____ SHIFT_LEFT
		RF_A<= "10000000000000000000000000000001";	
		ALUctr <= "1000";
		wait for 50 ns;
		for i in 1 to 2 loop
			ALUctr <= ALUctr +1;
			wait for 50 ns;	
		end loop;
		
		-- ROTATE
		RF_A<= "00011010101010101010101010100011";
		ALUctr <= "1100";
		wait for 50 ns;
		for i in 1 to 2 loop
			ALUctr <= ALUctr +1;
			wait for 50 ns;	
		end loop;
      wait;
   end process;
END;
