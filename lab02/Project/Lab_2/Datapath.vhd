----------------------------------------------------------------------------------
-- Create Date:    15:50:49 03/06/2019 
-- Design Name: 		TOP MODULE  LAB 2

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


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
			CU_ALUctr : in std_logic_vector(3 downto 0);
			CU_ALUSrc : in STD_LOGIC;
			CU_RF_WrEn : in STD_LOGIC;
			CU_MemtoReg : in STD_LOGIC;
			CU_PC_LdEn : in STD_LOGIC;
			CU_PC_sel : in STD_LOGIC;
			CU_RF_B_sel : in STD_LOGIC;
			CU_Exten : in STD_LOGIC;
			CU_shift : in STD_LOGIC;
			zero :out STD_LOGIC		
		  );
end Datapath;

architecture Behavioral of Datapath is


-----------------------------	ALUSTAGE---------------------------------
component ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in  STD_LOGIC;
           ALUctr : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  zero :out std_logic
			  );
end component;

-----------------------------	DECSTAGE---------------------------------
component DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  extension : in STD_LOGIC;
			  shifting : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;

--------------------------- MEMSTAGE (INCREMENTOR +400) --------------------------------
component MEMSTAGE is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_MEM_NewAddr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--------------------------- IFSTAGE (PROGRAMM COUNTER) --------------------------------
component IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;


signal s_RF_A :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_MEM_NewAddr :STD_LOGIC_VECTOR (31 downto 0);
signal s_PC :STD_LOGIC_VECTOR (31 downto 0);
signal s_Immed :STD_LOGIC_VECTOR (31 downto 0);


begin

ALUSTG: ALUSTAGE
	PORT MAP(
				  RF_A 	 => s_RF_A,
				  RF_B 	 => s_RF_B,
				  Immed	 => s_Immed,
				  ALUSrc  => CU_ALUSrc,
				  ALUctr  => CU_ALUctr,
				  ALU_out => s_ALU_out,
				  zero	 => zero
				 );

DECSTG: DECSTAGE
	PORT MAP(
				  Instr    => instructions,
				  RF_WrEn  => CU_RF_WrEn,
				  ALU_out  => s_ALU_out,
				  MEM_out  => data_dout,
				  RF_WrData_sel => CU_MemtoReg, 
				  RF_B_sel => CU_RF_B_sel,
				  Clk 	  => clk,
				  reset 	  => reset,
				  extension=> CU_Exten,
				  shifting => CU_shift,
				  Immed    => s_Immed,
				  RF_A     => s_RF_A,
				  RF_B     => s_RF_B
				 );

--Data Memory  
MEM: MEMSTAGE 
   PORT MAP( 
				ALU_MEM_Addr 	 => s_ALU_out,
				ALU_MEM_NewAddr => s_ALU_MEM_NewAddr       
				);


--Inst Memory
IN_FETCH : IFSTAGE 
   PORT MAP( 
				PC_Immed => s_Immed,
				PC_sel   => CU_PC_sel,
				PC_LdEn  => CU_PC_LdEn,
				Reset    => reset,   
				Clk 		=> clk,
				PC 		=> s_PC 
			  );

data_din <= s_RF_B;
instr_address <= s_PC(12 downto 2);
data_addr <=s_ALU_MEM_NewAddr(12 downto 2);
end Behavioral;

