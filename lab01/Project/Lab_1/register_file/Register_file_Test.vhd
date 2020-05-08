--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:54:07 02/20/2019
-- Design Name:   
-- Module Name:   H:/xilinx/Lab_1/register_file/Register_file_Test.vhd
-- Project Name:  Lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
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
Use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Register_file_Test IS
END Register_file_Test;
 
ARCHITECTURE behavior OF Register_file_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         Clk : IN  std_logic;
			reset: in STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal Din : std_logic_vector(31 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal Clk : std_logic := '0';
	signal reset: std_logic :='0';

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          Dout1 => Dout1,
          Dout2 => Dout2,
          Din => Din,
          WrEn => WrEn,
          Clk => Clk,
			 reset => reset
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
		wait for clk_period*2;
      reset<='0';
		wait for 200ns;

		WrEn <= '1';
		Awr <= "00111";
		Din <= "00000000000000011111111111111111" ;
		wait for clk_period;
		Awr <= "11100";
		Din <= "11111111111111100000000000000000" ;
		wait for clk_period;		
		WrEn <= '0';
		Ard1 <= "01000";
		Ard2 <= "00010";
		wait for clk_period;
		Ard1 <= "11100";
		Ard2 <= "00111";
      wait for clk_period;
		Ard1 <= "00000";
		Ard2 <= "11111";
		wait for clk_period;
		Ard1 <= "01000";
		Ard2 <= "00010";
      wait for clk_period;
		Ard1 <= "00000";
		Ard2 <= "10011";
		wait for clk_period;
		WrEn <= '1';
		Awr <= "11111";
		Ard1 <= "11111";
		Din <= "11111111111111111111111111111111" ;
		wait for clk_period;
		WrEn <= '0';
		Ard1 <= "11100";
		Ard2 <= "00111";
		wait for clk_period;
		Ard1 <= "01000";
		Ard2 <= "00010";
		wait for clk_period;
		Ard1 <= "11100";
		Ard2 <= "00111";
      wait for clk_period;
		Ard1 <= "01010";
		Ard2 <= "11111";
		wait for clk_period;
		WrEn <= '1';
		Awr <= "00000";
		Ard1 <= "00000";
		Din <= "11111111111111111111111111111111" ;
		
		wait;
   end process;

END;
