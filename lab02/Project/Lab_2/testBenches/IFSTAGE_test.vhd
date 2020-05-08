LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY IFSTAGE_test IS
END IFSTAGE_test;
 
ARCHITECTURE behavior OF IFSTAGE_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFSTAGE
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         PC : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal PC : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE PORT MAP (
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          Clk => Clk,
          PC => PC
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
		-------------------------------------------------------------
      Reset <= '1';
		wait for clk_period*2;
		
		--Reset is disabled but PC_load is also disabled
		Reset <= '0';
		PC_LdEn <= '0';
		PC_Sel <= '0'; -- PC <- PC + 4 bytes
		PC_Immed <= "00000000000000000000000001100000";
		wait for clk_period;
		
		--Load is now enabled, OUTPUT should be PC <- PC + 4 bytes
		PC_LdEn <= '1';
		wait for clk_period;
		
		--OUTPUT should now be PC <- PC + 4 bytes + Immediate
		PC_Sel <='1'; --PC <- PC + 4 bytes + Immediate
		wait for clk_period;
		
		--OUTPUT should now be PC <- PC + 4 bytes
		PC_Sel <= '0'; -- PC <- PC + 4 bytes
		wait for clk_period;
		
		--Changed Immediate Value, OUTPUT should now be PC <- PC + 4 + Immediate
		PC_Immed <= "00000000000011110000000000000000";
		PC_Sel <='1'; --PC <- PC + 4 bytes + Immediate
		wait for clk_period;
		
		--Load is now disabled, OUTPUT should be PC <- PC
		PC_Immed <= "00000000000000000000000000000000";
		PC_LdEn <= '0';
      wait;
		-------------------------------------------------------------
   end process;

END;
