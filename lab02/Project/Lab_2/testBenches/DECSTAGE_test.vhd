--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:50:12 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/zzhar/Desktop/LAB_2_con/Lab_2/testBenches/DECSTAGE_test.vhd
-- Project Name:  Lab_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DECSTAGE
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
 
ENTITY DECSTAGE_test IS
END DECSTAGE_test;
 
ARCHITECTURE behavior OF DECSTAGE_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         Clk : IN  std_logic;
         reset : IN  std_logic;
         extension : IN  std_logic;
         shifting : IN  std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal Clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal extension : std_logic := '0';
   signal shifting : std_logic := '0';

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECSTAGE PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          Clk => Clk,
          reset => reset,
          extension => extension,
          shifting => shifting,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
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
    reset <= '1';
      wait for 100 ns;
		reset <= '0';
      wait for Clk_period*2;
			-- write in "00001"(rd) add it with "00010"(rs) and store in "00011" (rd)	|RF_B_SEL='1'	
						--  op-rs-rd-rt-notUsed-func
						--"100000-00010-00001-00001-00000-110000"
			Instr <= "10000000010000010000100000110000";
         RF_WrEn <= '1';
			extension <= '0';
         shifting <= '0';
         ALU_out <= "01111111111111111111111111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd		
		wait for Clk_period*2;
			-- write in "00010"(rd) add it with "00001"(rs) and store in "00011" (rd)	|RF_B_SEL='1'	
						--   op  -  rs -  rd -  rt - N_U - func
						--"100000-00001-00010-00001-00000-110000"
			Instr <= "10000000001000100000100000110000";
         RF_WrEn <= '1';
         ALU_out <= "00111111111111111111111111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd	
		wait for Clk_period*2;
			-- TRY write in "00000"(rd) add it with "00010"(rs) and store in "00011" (rd)	|RF_B_SEL='1'	
						--  op-rs-rd-rt-notUsed-func
						--"100000-00010-00000-00001-00000-110000"
			Instr <= "10000000010000000000100000110000";
         RF_WrEn <= '1';
         ALU_out <= "01111111111111111111111111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd		
		wait for Clk_period*2;
			-- ori RF[rd] <- RF[rs] | ZeroFill(Imm)
						--  op   -  rs -  rd -   immediate
						--"110011-00010-00011-0000100000110000"
			Instr <= "11001100010000110000100000110000";
         RF_WrEn <= '1';
         ALU_out <= "01111111111111110000011111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd	
		wait for Clk_period*2;
			-- addi RF[rd] <- RF[rs] + SignExtend(Imm)
						--  op   -  rs -  rd -   immediate
						--"110000-00010-00011-1000100000110000"
			Instr <= "11000000010000111000100000110000";
         RF_WrEn <= '1';
			extension <= '1';
         shifting <= '0';
         ALU_out <= "01111110000111110000011111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd		
		wait for Clk_period*2;
			-- beq RF[rd] 	if (RF[rs] == RF[rd])
			--						PC <- PC + 4 + (SignExtend(Imm) << 2)
			--					else
			--						PC <- PC + 4
			
						--  op   -  rs -  rd -   immediate
						--"000000-00010-00001-1000100000110001"
			Instr <= "00000000010000011000100000110001";
         RF_WrEn <= '0';
			extension <= '1';
         shifting <= '1';
         ALU_out <= "01111111111111110000011111111111";					  
         MEM_out <= "00000000000000000000000000000001";	
         RF_WrData_sel <= '0';
         RF_B_sel <= '1';		--rd	
      wait;
   end process;
END;
