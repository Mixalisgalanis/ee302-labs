library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;


entity Datapath is
    Port( 
			clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			--Memory input signals 
			instructions : in std_logic_vector(31 downto 0);  
			instr_address :out std_logic_vector(10 downto 0);
			data_dout : in std_logic_vector(31 downto 0);  
			data_addr : out std_logic_vector(10 downto 0); 
			data_din  : out std_logic_vector(31 downto 0); 
			--contol unit signals
			CU_RF_WrEn : in STD_LOGIC;
			CU_RF_WrData_sel : in STD_LOGIC_VECTOR (1 downto 0);
			CU_RF_B_sel : in STD_LOGIC;
			CU_Exten : in STD_LOGIC;
			CU_ByteEnable : in STD_LOGIC;
			shift16 : in std_logic;
			CU_ALUctr : in std_logic_vector(3 downto 0);
			CU_ALUSrcA : in STD_LOGIC;
			CU_ALUSrcB : in STD_LOGIC_VECTOR(1 downto 0);
			CU_PC_LdEn : in STD_LOGIC;
			CU_PC_LdEn_cond : in STD_LOGIC;
			CU_PC_source : in STD_LOGIC_VECTOR(1 downto 0);
			zero : out STD_LOGIC;
			CU_CAUSEwrite : in std_logic;
			CU_intCause : in std_logic;
			CU_EPCwrite : in std_logic;
			address_range: out std_logic
		  );

end Datapath;

architecture Behavioral of Datapath is

-----------------------------	BYTE CHECKER-----------------------------
component Byte_Checker is
Port( 
	  MEM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
	  BYTE_ENABLE : in  STD_LOGIC;
	  BYTE_DATA : out  STD_LOGIC_VECTOR (31 downto 0)
	  );
end component;	

-----------------------------	ALUSTAGE---------------------------------
component ALUSTAGE is
    Port ( 
				RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
				RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
				PC: in  STD_LOGIC_VECTOR (31 downto 0);
				ALUSrcA : in std_logic ;
				ALUSrcB : in std_logic_vector(1 downto 0);
				Immed : in  STD_LOGIC_VECTOR (31 downto 0);
				Immed_sft2 : in  STD_LOGIC_VECTOR (31 downto 0);
				ALUctr : in  STD_LOGIC_VECTOR (3 downto 0);
				ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
				zero :out std_logic
			  );
end component;

-----------------------------	DECSTAGE---------------------------------
component DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out_post : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_out_pre : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           RF_B_sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  extension : in STD_LOGIC;
			  shift16 : in std_logic;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           Immed_sft2 : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  CAUSEwrite : in std_logic;
			  intCause : in std_logic;
			  EPCwrite : in std_logic;
			  EPC : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;

--------------------------- MEMSTAGE (INCREMENTOR +400) --------------------------------
component MEMSTAGE is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_MEM_NewAddr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--------------------------- REGISTER (PC,A,B,ALUout,IR,MDR) --------------------------------
component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component;


component mux_4to1_32bit is
	 Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0); 
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  D : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR(1 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;


component mux_2to1_32bit is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;


-----------------------------	SIGNALS ---------------------------------
signal s_RF_A_preReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_A_postReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B_preReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B_postReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out_preReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out_postReg :STD_LOGIC_VECTOR (31 downto 0);
signal s_MEM_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_MEM_NewAddr :STD_LOGIC_VECTOR (31 downto 0);
signal s_immed :STD_LOGIC_VECTOR (31 downto 0);
signal s_PC_SRC : STD_LOGIC_VECTOR (31 downto 0);
signal s_PC : STD_LOGIC_VECTOR (31 downto 0);
signal s_immed_sft2 : STD_LOGIC_VECTOR (31 downto 0);
signal s_PC_LdEn :std_logic;
--signal s_PC_jump:STD_LOGIC_VECTOR(31 downto 0);
signal S_hndlAddr:STD_LOGIC_VECTOR(31 downto 0);
signal s_EPC:STD_LOGIC_VECTOR(31 downto 0);
begin
----------------------------- PROGRAM COUNTER ----------------------------
-- ->We delete the ifstage and replace it with only one register connected to alu and register File.

s_PC_LdEn <= CU_PC_LdEn or CU_PC_LdEn_cond ;

PC_REG : regi port map ( 					--FINAL	
								clk => Clk,
								Data => s_PC_SRC,
								Dout => s_PC,
								WE => s_PC_LdEn,
								reset => Reset
								);
								
-- MULTIPLEXER PC_source
-- CU_PC_source = 00 -> loads ALU_out_preReg	tha contains PC +4 directly (any other op except of branch).							
-- CU_PC_source = 01 -> loads ALU_out_postReg that contains the result of the branch calculatin (BRANCH).
-- CU_PC_source = 10 -> loads Result of concatenation of left-shifted(2) 26 bits of instructions with upper 4 bits of PC (jump).		
-- CU_PC_source = 11 -> loads the exception handler address. (EXCEPTION)

HANDLE_ADDR: mux_2to1_32bit
	PORT MAP (
					A 	 => x"00000030",	--'0'
					B 	 => x"00000040",	--'1'
					SEL => CU_intCause,
					X   => S_hndlAddr
					);


--s_PC_jump <=  s_PC(31 downto 28) & STD_LOGIC_VECTOR(shift_left(signed(instructions(27 downto 0)),2));
PC_source: mux_4to1_32bit
	PORT MAP (
					A 	 => s_ALU_out_preReg,
					B 	 => s_ALU_out_postReg,
					C	 => std_logic_vector(unsigned(s_EPC) + x"00000004") ,			
					D	 => S_hndlAddr,
					SEL => CU_PC_source,
					X   => s_PC_SRC
					);
					
----------------------------- RF_A REGISTER ------------------------------								
RF_A : regi
	PORT MAP(
					clk => clk,
					reset => reset,
					Data => s_RF_A_preReg,
					Dout => s_RF_A_postReg,
					We => '1'
				);
----------------------------- RF_B REGISTER ------------------------------
RF_B : regi
	PORT MAP(
					clk => clk,
					reset => reset,
					Data => s_RF_B_preReg,
					Dout => s_RF_B_postReg,
					We => '1'
				);
---------------------------- ALUout REGISTER ------------------------------
ALU_OUT_RG : regi
	PORT MAP(
					clk => clk,
					reset => reset,
					Data => s_ALU_out_preReg,
					Dout => s_ALU_out_postReg,
					We => '1'
				);
----------------------------- ALUSTAGE ------------------------------				
ALUSTG: ALUSTAGE
	PORT MAP(
				  RF_A 	 	=> s_RF_A_postReg,
				  RF_B 	 	=> s_RF_B_postReg,
				  PC			=> s_PC,
				  ALUSrcA 	=> CU_ALUSrcA,
				  ALUSrcB	=> CU_ALUSrcB,
				  Immed	 	=> s_immed,
				  Immed_sft2=> s_immed_sft2,
				  ALUctr   	=> CU_ALUctr,
				  ALU_out 	=> s_ALU_out_preReg,
				  zero	 	=> zero		
				 );
----------------------------- DECSTAGE ------------------------------	
DECSTG: DECSTAGE
	PORT MAP(
				  Instr    => instructions,
				  RF_WrEn  => CU_RF_WrEn,
				  ALU_out_post  => s_ALU_out_postReg,
				  ALU_out_pre  => s_ALU_out_preReg,
				  MEM_out  => s_MEM_out,
				  RF_WrData_sel => CU_RF_WrData_sel, 
				  RF_B_sel => CU_RF_B_sel,
				  Clk 	  => clk,
				  reset 	  => reset,
				  extension=> CU_Exten,
				  shift16  => shift16,
				  Immed    => s_immed,
				  Immed_sft2=> s_immed_sft2,
				  RF_A     => s_RF_A_preReg,
				  RF_B     => s_RF_B_preReg,
				  CAUSEwrite => CU_CAUSEwrite,
				  intCause => CU_intCause,
				  EPCwrite => CU_EPCwrite,
			     EPC 	  => s_EPC
				 );
				 
--Data Memory  
MEM: MEMSTAGE 
   PORT MAP( 
				ALU_MEM_Addr 	 => s_ALU_out_postReg,
				ALU_MEM_NewAddr => s_ALU_MEM_NewAddr       
				);



ByteCheckerLoad : Byte_Checker
	PORT MAP (
					MEM_DATA => data_dout,
					BYTE_ENABLE => CU_ByteEnable,
					BYTE_DATA => s_MEM_out
					);
					

ByteCheckerStore : Byte_Checker
	PORT MAP (
					MEM_DATA => s_RF_B_postReg,
					BYTE_ENABLE => CU_ByteEnable,
					BYTE_DATA => data_din
					);
----  This is to check if the loading memory address is acceptable for our range.If not then address_range='1'					
addr_RNG: process(s_ALU_out_postReg,CU_ByteEnable)
	begin
		if ((s_ALU_out_postReg >= "00000000000000000000000000000000") and (s_ALU_out_postReg <= "00000000000000000000100000000000") and (CU_ByteEnable='0')) then 
			address_range <='0';        
		elsif ((s_ALU_out_postReg >= "00000000000000000000000000000000") and (s_ALU_out_postReg <= "00000000000000000010000000000000") and (CU_ByteEnable='1'))	then 
			address_range <='0';
		else 
			address_range <='1';
		end if;
	end process;
	
instr_address <= s_PC(12 downto 2);
data_addr <=s_ALU_MEM_NewAddr(12 downto 2);

end Behavioral;

