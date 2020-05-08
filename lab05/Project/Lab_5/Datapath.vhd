----------------------------------------------------------------------------------

-- Design Name: 		TOP MODULE  LAB 5

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
			data_addr : out std_logic_vector(10 downto 0); 		--GET IT FROM EX/MEM PIPELINE
			data_din  : out std_logic_vector(31 downto 0); 		--GET IT FROM EX/MEM PIPELINE	
			--contol unit signals
			CU_ALUctr : in std_logic_vector(3 downto 0);
			CU_ALUSrc : in STD_LOGIC;
			CU_RF_WrEn : in STD_LOGIC;
			CU_MemtoReg : in STD_LOGIC;
			CU_PC_LdEn : in STD_LOGIC;
			CU_PC_sel : in STD_LOGIC;
			CU_RF_B_sel : in STD_LOGIC;
			CU_Exten : in STD_LOGIC;
			CU_ByteEnable : in STD_LOGIC;
			CU_shift16 : in std_logic;
			CU_branch: in std_logic_vector(1 downto 0);
			CU_MemWr		: in std_logic;
			MEM_WE	: out std_logic;
			instructions_out: out std_logic_vector(31 downto 0)
		  );

end Datapath;

architecture Behavioral of Datapath is

component Byte_Checker is
Port( 
	  MEM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
	  BYTE_ENABLE : in  STD_LOGIC;
	  BYTE_DATA : out  STD_LOGIC_VECTOR (31 downto 0)
	  );
end component;	


-----------------------------	ALUSTAGE---------------------------------
component ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus4 : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in  STD_LOGIC;
           ALUctr : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus4_IM : out  STD_LOGIC_VECTOR (31 downto 0);
			  zero :out std_logic;
			  ALU_out_mem: in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_WB_value: in  STD_LOGIC_VECTOR (31 downto 0);
			  MEM_write_data: out STD_LOGIC_VECTOR (31 downto 0);
			  forward_A : in STD_LOGIC_VECTOR(1 downto 0);
			  forward_B : in STD_LOGIC_VECTOR(1 downto 0)	
			  );
end component;

-----------------------------	DECSTAGE---------------------------------
component DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_AWR_in :in STD_LOGIC_VECTOR(4 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  extension : in STD_LOGIC;
			  shift16 : in std_logic;
			  --OUTPUTS
			  RF_AWR_OUT : out STD_LOGIC_VECTOR (4 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  RS  : out STD_LOGIC_VECTOR (4 downto 0);
			  RT  : out STD_LOGIC_VECTOR (4 downto 0);
			  RF_WB_value:out  STD_LOGIC_VECTOR (31 downto 0)
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
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus4: out  STD_LOGIC_VECTOR (31 downto 0));
end component;

----------------------------------------------------------------------------------------
component IF_ID_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  we: in STD_LOGIC;
			  inst_in: in STD_LOGIC_VECTOR(31 downto 0);
			  inst_out: out STD_LOGIC_VECTOR(31 downto 0);
			  pc_in: in STD_LOGIC_VECTOR(31 downto 0);
			  pc_out: out STD_LOGIC_VECTOR(31 downto 0)
			  );
end component;

component ID_EX_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  we: in STD_LOGIC;
			  pc_in: in STD_LOGIC_VECTOR(31 downto 0);
			  pc_out: out STD_LOGIC_VECTOR(31 downto 0);
			  RF_A_in : in STD_LOGIC_VECTOR(31 downto 0);
			  RF_A_out:out STD_LOGIC_VECTOR(31 downto 0);
			  RF_B_in : in STD_LOGIC_VECTOR(31 downto 0);
			  RF_B_out:out STD_LOGIC_VECTOR(31 downto 0);
			  Immed_in : in STD_LOGIC_VECTOR(31 downto 0);
			  Immed_out: out STD_LOGIC_VECTOR(31 downto 0);
			  reg_dst_in: in STD_LOGIC_VECTOR(4 downto 0);
			  reg_dst_out: out STD_LOGIC_VECTOR(4 downto 0);
			  CU_ALUctr_in : in std_logic_vector(3 downto 0);
			  CU_ALUctr_out : out std_logic_vector(3 downto 0);
			  CU_ALU_src_in : in STD_LOGIC;
			  CU_ALU_src_out : out STD_LOGIC;
			  EX_MEM_SIG_IN : in STD_LOGIC_VECTOR(4 downto 0);
			  EX_MEM_SIG_OUT : out STD_LOGIC_VECTOR(4 downto 0);
			  MEM_WB_SIG_IN : in STD_LOGIC_VECTOR(1 downto 0);
			  MEM_WB_SIG_OUT : out STD_LOGIC_VECTOR(1 downto 0);
			  RS_IN:in STD_LOGIC_VECTOR(4 downto 0);
			  RS_OUT:out STD_LOGIC_VECTOR(4 downto 0);
			  RT_IN:in STD_LOGIC_VECTOR(4 downto 0);
			  RT_OUT:out STD_LOGIC_VECTOR(4 downto 0)			 
			  );
end component;

component EX_MEM_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           we : in  STD_LOGIC;
			  pc_in: in STD_LOGIC_VECTOR (31 downto 0);
			  pc_out:out STD_LOGIC_VECTOR (31 downto 0);
			  zero_in:in STD_LOGIC;
			  zero_out:out STD_LOGIC;
			  ALU_out_in:in STD_LOGIC_VECTOR (31 downto 0);
			  ALU_out_out:out STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_in:in STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_out:out STD_LOGIC_VECTOR (31 downto 0);
			  reg_dst_in:in STD_LOGIC_VECTOR (4 downto 0);
			  reg_dst_out:out STD_LOGIC_VECTOR (4 downto 0);
			  EX_MEM_SIG_IN : in STD_LOGIC_VECTOR(4 downto 0);
			  pc_sel_out: out std_logic;
			  branch_out: out std_logic_vector(1 downto 0);
			  bt_EN_out: out std_logic;
			  mem_we_out: out std_logic;
			  MEM_WB_SIG_IN : in STD_LOGIC_VECTOR(1 downto 0);
			  MEM_WB_SIG_OUT : out STD_LOGIC_VECTOR(1 downto 0)
			  );
end component;

component mux_1_1 is
    Port ( zero : in  STD_LOGIC;
           branch : in  STD_LOGIC_VECTOR (1 downto 0);
           zero_out : out  STD_LOGIC);
end component;

component MEM_WB_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           we : in  STD_LOGIC;
			  ALU_out_in:in STD_LOGIC_VECTOR (31 downto 0);
			  ALU_out_out:out STD_LOGIC_VECTOR (31 downto 0);
			  Meme_out_in:in STD_LOGIC_VECTOR (31 downto 0);
			  Meme_out_out:out STD_LOGIC_VECTOR (31 downto 0);
			  reg_dst_in:in STD_LOGIC_VECTOR (4 downto 0);
			  reg_dst_out:out STD_LOGIC_VECTOR (4 downto 0);
			  MEM_WB_SIG_IN : in STD_LOGIC_VECTOR(1 downto 0);
			  memToReg : out  STD_LOGIC;
			  RF_we : out  STD_LOGIC
			  );
end component;

component Hazard_UNIT is
    Port ( ALU_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU_rt : in  STD_LOGIC_VECTOR (4 downto 0);
			  DEC_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rt : in  STD_LOGIC_VECTOR (4 downto 0);
			  DEC_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           MEM_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           WB_rd : in  STD_LOGIC_VECTOR (4 downto 0);
			  RG_dst: in STD_LOGIC_VECTOR(4 downto 0);
           RF_we_MEM : in  STD_LOGIC;
           RF_we_WB : in  STD_LOGIC;
           Forward_A : out  STD_LOGIC_VECTOR (1 downto 0);
           Forward_B : out  STD_LOGIC_VECTOR (1 downto 0);
			  memToReg : in std_logic;
			  ST_PC : out  STD_LOGIC;
			  ST_IF_ID : out  STD_LOGIC;
			  CLR_ID_EX : out  STD_LOGIC);
end component;


-------------------------------------SIGNALS---------------------------------------
signal s_RF_A_in :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_A_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B_in :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B_out_1 :STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B_out_2 :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out_in :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_out_out_2 :STD_LOGIC_VECTOR (31 downto 0);
signal s_MEM_out_in :STD_LOGIC_VECTOR (31 downto 0);
signal s_MEM_out_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_ALU_MEM_NewAddr :STD_LOGIC_VECTOR (31 downto 0);
signal s_Immed_in :STD_LOGIC_VECTOR (31 downto 0);
signal s_Immed_out :STD_LOGIC_VECTOR (31 downto 0);
signal s_PC :STD_LOGIC_VECTOR (31 downto 0);
signal RF_AWR_in: STD_LOGIC_VECTOR(4 downto 0);
signal RF_AWR_out_1: STD_LOGIC_VECTOR(4 downto 0);
signal RF_AWR_out_2: STD_LOGIC_VECTOR(4 downto 0);
signal RF_AWR_out_3: STD_LOGIC_VECTOR(4 downto 0);
signal s_instr:STD_LOGIC_VECTOR (31 downto 0);
signal s_pc_pls4_in:STD_LOGIC_VECTOR (31 downto 0);
signal s_PC_plus4_IM_in:STD_LOGIC_VECTOR (31 downto 0);
signal s_PC_plus4_IM_out:STD_LOGIC_VECTOR (31 downto 0);
signal s_pc_pls4_out_1:STD_LOGIC_VECTOR (31 downto 0);
signal s_pc_pls4_out_2:STD_LOGIC_VECTOR (31 downto 0);
signal s_zero_in :STD_LOGIC;
signal s_zero_out :STD_LOGIC;
signal s_zero :STD_LOGIC;
signal s_EX_MEM_sig_in:STD_LOGIC_VECTOR (4 downto 0);
signal s_EX_MEM_sig_out:STD_LOGIC_VECTOR (4 downto 0);
signal s_MEM_WB_sig_in:STD_LOGIC_VECTOR (1 downto 0);
signal s_MEM_WB_sig_out_1:STD_LOGIC_VECTOR (1 downto 0);
signal s_MEM_WB_sig_out_2:STD_LOGIC_VECTOR (1 downto 0);
signal s_CU_ALUctr:STD_LOGIC_VECTOR (3 downto 0);
signal s_CU_ALUSrc:STD_LOGIC;
signal s_CU_pc_sel:STD_LOGIC;
signal s_CU_byte_en:STD_LOGIC;
signal s_CU_mem_we:STD_LOGIC;
signal s_CU_memToReg:STD_LOGIC;
signal s_CU_RF_we:STD_LOGIC;
signal s_CU_branch:STD_LOGIC_VECTOR(1 downto 0);
signal s_Forward_A:STD_LOGIC_VECTOR(1 downto 0);
signal s_Forward_B:STD_LOGIC_VECTOR(1 downto 0);
signal s_pc_sel_final:STD_LOGIC;

signal s_RT_IN:STD_LOGIC_VECTOR(4 downto 0);
signal s_RT_OUT:STD_LOGIC_VECTOR(4 downto 0);
signal s_RS_OUT:STD_LOGIC_VECTOR(4 downto 0);
signal s_RS_IN:STD_LOGIC_VECTOR(4 downto 0);
signal S_RF_WB_value:STD_LOGIC_VECTOR(31 downto 0);
signal s_RF_B_out_ALUS:STD_LOGIC_VECTOR(31 downto 0);

signal s_ST_PC : STD_LOGIC;
signal s_ST_IF_ID : STD_LOGIC;
signal s_CLR_ID_EX : STD_LOGIC;

begin



HAZ_U:Hazard_UNIT 
	PORT MAP(
				ALU_rs 	 => s_RS_OUT,
				ALU_rt 	 => s_RT_OUT,
				DEC_rs 	 => s_RS_IN,
				DEC_rt 	 => s_RT_IN,
				DEC_rd	 => RF_AWR_in,
				MEM_rd 	 => RF_AWR_out_2,
				WB_rd		 => RF_AWR_out_3,
				RG_dst	 => RF_AWR_out_1,
				RF_we_MEM => s_MEM_WB_sig_out_2(1),
				RF_we_WB	 => s_CU_RF_we,
				Forward_A => s_Forward_A,
				Forward_B => s_Forward_B,
				memToReg  => s_MEM_WB_sig_out_1(0),--memToReg
				ST_PC 	 => s_ST_PC,
				ST_IF_ID  => s_ST_IF_ID,
				CLR_ID_EX => s_CLR_ID_EX
				);
			  
			  
--Inst Memory
s_pc_sel_final<=s_CU_pc_sel and s_zero;
IN_FETCH : IFSTAGE 
   PORT MAP( 
				PC_Immed => s_PC_plus4_IM_out,      	-- GET FROM EX/MEM PIPELINE,
				PC_sel   => s_pc_sel_final,		-- GET IT FROM EX/MEM PIPELINE
				PC_LdEn  => s_ST_PC,
				Reset    => reset,   
				Clk 		=> clk,
				PC 		=> s_PC,
				PC_plus4 => s_pc_pls4_in
			  );

--IF/ID PIPELINE
IF_ID:IF_ID_pipeline
	PORT MAP(
				clk 		=> clk,
			   reset 	=> reset,
			   we			=> s_ST_IF_ID,---------------ctrl
			   inst_in	=> instructions,
			   inst_out => s_instr,
			   pc_in		=> s_pc_pls4_in,
			   pc_out	=> s_pc_pls4_out_1
			  );
				

DECSTG: DECSTAGE
	PORT MAP(	--INPUTS
				  Clk 	  		=> clk,
				  reset 	  		=> reset,
				  extension		=> CU_Exten,
				  shift16  		=> CU_shift16,
				  RF_B_sel 		=> CU_RF_B_sel,
				  -- - - - - - - - - - - - 
				  Instr    		=> s_instr,					--GET IT FROM IF/ID PIPELINE
				  RF_AWR_IN		=>	RF_AWR_out_3,			--GET IT FROM MEM/WB PIPELINE
				  ALU_out  		=> s_ALU_out_out_2,		--GET IT FROM MEM/WB PIPELINE
				  MEM_out  		=> s_MEM_out_out,			--GET IT FROM MEM/WB PIPELINE
				  RF_WrData_sel=> s_CU_memToReg,			--GET IT FROM MEM/WB PIPELINE
				  RF_WrEn  		=> s_CU_RF_we,     		--GET IT FROM MEM/WB PIPELINE
				  --OUTPUTS
				  Immed    		=> s_Immed_in,				--GIVE IT TO ID/EX PIPELINE
				  RF_AWR_OUT	=> RF_AWR_in,				--GIVE IT TO ID/EX PIPELINE
				  RF_A     		=> s_RF_A_in,				--GIVE IT TO ID/EX PIPELINE
				  RF_B     		=> s_RF_B_in,				--GIVE IT TO ID/EX PIPELINE
				  RS 				=> s_RS_IN,
				  RT				=> s_RT_IN,
				  RF_WB_value  => S_RF_WB_value
				 );



--ID/EX PIPELINE

s_EX_MEM_sig_in(0) <= CU_PC_sel;
s_EX_MEM_sig_in(1) <= CU_branch(0);
s_EX_MEM_sig_in(2) <= CU_branch(1);
s_EX_MEM_sig_in(3) <= CU_ByteEnable;
s_EX_MEM_sig_in(4) <= CU_MemWr;

s_MEM_WB_sig_in(0) <= CU_MemtoReg;
s_MEM_WB_sig_in(1) <= CU_RF_WrEn;	

ID_EX: ID_EX_pipeline
    PORT MAP(
				  clk 		 => clk,
				  reset 		 => s_CLR_ID_EX,
				  we			 => '1',---------------ctrl
				  pc_in		 => s_pc_pls4_out_1,		-- GET IT FROM IF/ID PIPELINE
				  pc_out		 => s_pc_pls4_out_2,		-- GIVE IT TO ALUSTAGE
				  RF_A_in 	 => s_RF_A_in,      		-- GET IT FROM DECSTAGE 
				  RF_A_out	 => s_RF_A_out,			-- GIVE IT TO ALUSTAGE
				  RF_B_in 	 => s_RF_B_in,				-- GET IT FROM DECSTAGE 
				  RF_B_out	 => s_RF_B_out_1,			-- GIVE IT TO ALUSTAGE AND EX/MEM PIPELINE
				  Immed_in 	 => s_Immed_in,			-- GET IT FROM DECSTAGE 
				  Immed_out	 => s_Immed_out,			-- GIVE IT TO ALUSTAGE
				  reg_dst_in => RF_AWR_in,				-- GET IT FROM DECSTAGE 
				  reg_dst_out	 => RF_AWR_out_1,		-- GIVE IT TO EX/MEM PIPELINE AND HAZARD UNIT
				  CU_ALUctr_in  => CU_ALUctr,			
				  CU_ALUctr_out => s_CU_ALUctr,		-- GIVE TO ALUSTAGE
				  CU_ALU_src_in => CU_ALUSrc,
				  CU_ALU_src_out=> s_CU_ALUSrc,		-- GIVE TO ALUSTAGE
				  EX_MEM_SIG_IN => s_EX_MEM_sig_in,	
				  EX_MEM_SIG_OUT=> s_EX_MEM_sig_out,-- GIVE TO EX/MEM PIPELINE
				  MEM_WB_SIG_IN => s_MEM_WB_sig_in, 
				  MEM_WB_SIG_OUT=> s_MEM_WB_sig_out_1,-- GIVE TO EX/MEM PIPELINE
				  RS_IN  => s_RS_IN,
				  RS_OUT => s_RS_OUT,
			  	  RT_IN  => s_RT_IN,
				  RT_OUT => s_RT_OUT
			  );	
			  
ALUSTG: ALUSTAGE
	PORT MAP(
				  PC_plus4=> s_pc_pls4_out_2, 		-- GET IT FROM ID/EX PIPELINE
				  RF_A 	 => s_RF_A_out,				-- GET IT FROM ID/EX PIPELINE
				  RF_B 	 => s_RF_B_out_1,				-- GET IT FROM ID/EX PIPELINE	
				  Immed	 => s_Immed_out,				-- GET IT FROM ID/EX PIPELINE
				  ALUSrc  => s_CU_ALUSrc,				-- GET IT FROM ID/EX PIPELINE
				  ALUctr  => s_CU_ALUctr,				-- GET IT FROM ID/EX PIPELINE
				  ALU_out => s_ALU_out_in,				-- GIVE IT TO EX/MEM PIPELINE
				  PC_plus4_IM 	=> s_PC_plus4_IM_in,	-- GIVE IT TO EX/MEM PIPELINE
				  zero	 		=> s_zero_in,					-- GIVE IT TO EX/MEM PIPELINE
				  ALU_out_mem	=> s_ALU_out_out,
				  RF_WB_value	=> S_RF_WB_value,
				  MEM_write_data=> s_RF_B_out_ALUS,
				  forward_A 	=> s_Forward_A,
				  forward_B 	=> s_Forward_B
				 );


-- EX/MEM PIPELINE
EX_MEM: EX_MEM_pipeline
    PORT MAP(
				 clk 		    => clk,
			    reset 		 => reset,
				 we			 => '1',---------------ctrl
				 pc_in       => s_PC_plus4_IM_in,	-- GET IT FROM ALUSTAGE 	
				 pc_out      => s_PC_plus4_IM_out,  -- GIVE IT TO IFSTAGE
				 zero_in 	 => s_zero_in,				-- GET IT FROM ALUSTAGE 
				 zero_out	 => s_zero_out,			-- GIVE IT ZERO MUX
				 ALU_out_in	 => s_ALU_out_in,			-- GET IT FROM ALUSTAGE 
				 ALU_out_out => s_ALU_out_out,		-- GIVE IT TO MEMSTAGE AND MEM/WB PIPELINE
				 RF_B_in		 => s_RF_B_out_ALUS,		-- GET IT FROM ALUSTAGE
				 RF_B_out    => s_RF_B_out_2,			-- GIVE IT TO MEMEORY FOR DATA INPUT
				 reg_dst_in  => RF_AWR_out_1,			-- GET IT FROM ID/EX PIPELINE
				 reg_dst_out => RF_AWR_out_2,			-- GIVE IT TO MEM/WB PIPELINE
				 EX_MEM_SIG_IN => s_EX_MEM_sig_out,
				 pc_sel_out 	=> s_CU_pc_sel,
			    branch_out		=> s_CU_branch,
			    bt_EN_out		=> s_CU_byte_en,
			    mem_we_out		=> s_CU_mem_we,
			    MEM_WB_SIG_IN => s_MEM_WB_sig_out_1,
			    MEM_WB_SIG_OUT=> s_MEM_WB_sig_out_2
				 
				);
	
zr: mux_1_1 
    PORT MAP( 
				 zero => s_zero_out,				-- GET IT FROM EX/MEM PIPELINE
             branch => s_CU_branch ,		-- GET IT FROM EX/MEM PIPELINE
             zero_out => s_zero				-- GIVE IT TO IFSTAGE
			  );
	

-- Data Memory  
MEM: MEMSTAGE 
   PORT MAP( 
				ALU_MEM_Addr 	 => s_ALU_out_out,		-- GET IT FROM EX/MEM PIPELINE
				ALU_MEM_NewAddr => s_ALU_MEM_NewAddr       
				);




-- MEM/WB PIPELINE
MEM_WB: MEM_WB_pipeline
    PORT MAP(
				 clk 		    => clk,
			    reset 		 => reset,
				 we			 => '1',---------------ctrl
				 ALU_out_in	 => s_ALU_out_out,			-- GET IT FROM EX/MEM PIPELINE
				 ALU_out_out => s_ALU_out_out_2,			-- GIVE IT TO DECSTAGE
				 Meme_out_in => s_MEM_out_in,				-- GET IT FROM ID/EX PIPELINE	
				 Meme_out_out=> s_MEM_out_out,			-- GIVE IT TO DECSTAGE	
				 reg_dst_in  => RF_AWR_out_2,				-- GET IT FROM EX/MEM PIPELINE
				 reg_dst_out => RF_AWR_out_3,				-- GIVE IT TO MEM/WB PIPELINE
				 MEM_WB_SIG_IN => s_MEM_WB_sig_out_2,	-- GET IT FROM EX/MEM PIPELINE
				 memToReg 	 => s_CU_memToReg,			-- GIVE IT TO DECSTAGE 
				 RF_we		 => s_CU_RF_we					-- GIVE IT TO DECSTAGE
				);




ByteCheckerLoad : Byte_Checker
	PORT MAP (
					MEM_DATA 	=> data_dout,
					BYTE_ENABLE => s_CU_byte_en,			-- GET IT FROM EX/MEM PIPELINE
					BYTE_DATA 	=> s_MEM_out_in         -- GIVE IT TO MEM/WB PIPELINE
					);
					

ByteCheckerStore : Byte_Checker
	PORT MAP (
					MEM_DATA 	=> s_RF_B_out_2,		-- GET IT FROM EX/MEM PIPELINE
					BYTE_ENABLE =>	 s_CU_byte_en,		-- GET IT FROM EX/MEM PIPELINE
					BYTE_DATA 	=> data_din
					);


				
instr_address <= s_PC(12 downto 2);
data_addr <=s_ALU_MEM_NewAddr(12 downto 2);
instructions_out<=s_instr;
MEM_WE <= s_CU_mem_we;									--GET IT FROM EX/MEM PIPELINE
end Behavioral;

