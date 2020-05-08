--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:10:45 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/zzhar/Desktop/LAB_2_con/Lab_2/testBenches/Memory_T_test.vhd
-- Project Name:  Lab_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory_T
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
 
ENTITY Memory_T_test IS
END Memory_T_test;
 
ARCHITECTURE behavior OF Memory_T_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_T
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         data_we : IN  std_logic;
         CU_PC_sel : IN  std_logic;
         CU_PC_LdEn : IN  std_logic;
         s_ALU_out : IN  std_logic_vector(31 downto 0);
         s_data_din : IN  std_logic_vector(31 downto 0);
         data_dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_we : std_logic := '0';
   signal CU_PC_sel : std_logic := '0';
   signal CU_PC_LdEn : std_logic := '0';
   signal s_ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal s_data_din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal data_dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_T PORT MAP (
          clk => clk,
          reset => reset,
          data_we => data_we,
          CU_PC_sel => CU_PC_sel,
          CU_PC_LdEn => CU_PC_LdEn,
          s_ALU_out => s_ALU_out,
          s_data_din => s_data_din,
          data_dout => data_dout
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
			reset <= '1';
      wait for 100 ns;	
			reset      <= '0';
			data_we    <= '0';
         CU_PC_sel  <= '0';
         CU_PC_LdEn <= '0';
         s_ALU_out  <= "10101010100000000000001010101010";
         s_data_din <= "10101010100000000000000000000000";
      wait for clk_period*3;
			data_we    <= '0';
         CU_PC_sel  <= '1';
         CU_PC_LdEn <= '0';
         s_ALU_out  <= "10101010100000000000001010101010";
         s_data_din <= "10101010100000000000000000000000";
      wait for clk_period*3;
			data_we    <= '1';
         CU_PC_sel  <= '0';
         CU_PC_LdEn <= '0';
         s_ALU_out  <= "10101010100000000000001010101010";
         s_data_din <= "10101010100000000000000000000000";
		 wait for clk_period*3;
			data_we    <= '0';
         CU_PC_sel  <= '1';
         CU_PC_LdEn <= '1';
         s_ALU_out  <= "10101010100000000000001010101010";
         s_data_din <= "10101010100000000000000000000000";
		wait for clk_period*3;
			data_we    <= '0';
         CU_PC_sel  <= '0';
         CU_PC_LdEn <= '0';
         s_ALU_out  <= "10101010100000000000001010101010";
         s_data_din <= "10101010100000000000000000000000";
      wait;
   end process;

END;
