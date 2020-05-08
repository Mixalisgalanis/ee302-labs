library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;


entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out_post : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_out_pre : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           RF_B_sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  extension: in std_logic;
			  shift16: in std_logic;
			  Immed_sft2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  CAUSEwrite : in std_logic;
			  intCause : in std_logic;
			  EPCwrite : in std_logic;
			  EPC : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end DECSTAGE;

architecture Structural of DECSTAGE is

component register_file is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component;


component Mux10To5 is
    Port ( 
			  Mux_in_A : in  STD_LOGIC_VECTOR (4 downto 0);
           Mux_in_B : in  STD_LOGIC_VECTOR (4 downto 0);
           Mux_sel  : in  STD_LOGIC;
           Mux_out : out  STD_LOGIC_VECTOR (4 downto 0)
			  );
end component;

component mux_2to1_32bit is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;


component Immed_extender is
    Port ( 
			  imm16 : in  STD_LOGIC_VECTOR (15 downto 0);
			  shift16: in std_logic;
			  extension: in std_logic;
           imm32 : out  STD_LOGIC_VECTOR (31 downto 0));
end component;


Component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset : in  STD_LOGIC);
end Component;

component mux_4to1_32bit is
	 Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0); 
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  D : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR(1 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal S_reg2 : STD_LOGIC_VECTOR (4 downto 0); 
signal S_wrData : STD_LOGIC_VECTOR (31 downto 0);
signal S_Immed : STD_LOGIC_VECTOR (31 downto 0);

--unconnected
signal S_cause_pre : STD_LOGIC_VECTOR (31 downto 0);
signal S_cause_post : STD_LOGIC_VECTOR (31 downto 0);



begin

ImmEX: Immed_extender
	PORT MAP (
				imm16		 => Instr(15 downto 0),
				extension => extension,
				imm32	    => S_Immed,
				shift16	 => shift16
				);

RF: register_file 
	PORT MAP ( 	
					Ard1  => Instr(25 downto 21),	--rs
					Ard2  => S_reg2,					--rd or rt
					Awr   =>	Instr(20 downto 16), --rd
					Dout1 => RF_A,
					Dout2 => RF_B,
					Din   => S_wrData,
					WrEn  => RF_WrEn,    				
					Clk   => Clk,
					reset => reset						
					);

READ_REGISTER: Mux10To5
	PORT MAP (
					Mux_in_A => Instr(15 downto 11),		--'0' rt
					Mux_in_B => Instr(20 downto 16),		--'1' rd
					Mux_sel  => RF_B_sel,
					Mux_out  => S_reg2
					);


WRITE_DATA: mux_4to1_32bit
	PORT MAP (
					A 	 => S_cause_post,	 	--'00'
					B 	 => MEM_out,		 	--'01'
					C	 => (others=>'0') ,	--'10'			
					D	 => ALU_out_post,		--'11'
					SEL => RF_WrData_sel,
					X   => S_wrData
					);

EPC_RG: regi 
		PORT MAP ( 	clk 	=> Clk,
						Data 	=> std_logic_vector(unsigned(ALU_out_pre) ),
						Dout 	=> EPC,
						WE		=> EPCwrite,
						reset => reset
						);	
-----------------------------TODO------------------------------------						
CAUSE_RG: regi 
		PORT MAP ( 	clk 	=> Clk,
						Data 	=> S_cause_pre,
						Dout 	=> S_cause_post,	
						WE		=> CAUSEwrite,
						reset => reset
						);				
			
CAUSE_MUX: mux_2to1_32bit
	PORT MAP (
					A 	 => x"00000111",	--'0'
					B 	 => x"00111000",	--'1'
					SEL => intCause,
					X   => S_cause_pre
					);

Immed_sft2 <= STD_LOGIC_VECTOR(shift_left(signed(S_Immed),2));
Immed <= S_Immed;
end Structural;