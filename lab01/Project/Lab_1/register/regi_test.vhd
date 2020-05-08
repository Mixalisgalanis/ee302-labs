--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:20:07 02/16/2019
-- Design Name:   
-- Module Name:   H:/xilinx/Lab_1/regi_test.vhd
-- Project Name:  Lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: regi
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
 
 
ENTITY regi_test IS
END regi_test;
 
ARCHITECTURE behavior OF regi_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT regi
    PORT(
         clk : IN  std_logic;
         Data : IN  std_logic_vector(31 downto 0);
         Dout : OUT  std_logic_vector(31 downto 0);
         WE : IN  std_logic;
			reset: in STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Data : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';
	signal reset: std_logic :='0';

 	--Outputs
   signal Dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: regi PORT MAP (
          clk => clk,
          Data => Data,
          Dout => Dout,
          WE => WE,
			 reset=> reset
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		WE<= '0';
		Data <= "11111111111111111111111111111111";
		wait for clk_period*2;
		WE<= '1';
		Data <= "11111111111111111111111111111111";
		wait for clk_period*2;
		WE<= '0';
		Data <= "00000000000000000111111111111111";
		wait for clk_period*2;
		WE<= '1';
		Data <= "11111111111111100000000000000000";
		wait for clk_period*2;
		WE <='0';
		reset<='1';
		wait for clk_period*2;
      reset<='0';
		wait;
   end process;

END;
