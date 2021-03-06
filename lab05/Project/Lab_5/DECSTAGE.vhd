

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  RF_AWR_in :in STD_LOGIC_VECTOR(4 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  extension: in std_logic;
			  shift16: in std_logic;
			  --OUTPUTS
			  RF_AWR_OUT : out STD_LOGIC_VECTOR (4 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  RS  : out STD_LOGIC_VECTOR (4 downto 0);
			  RT  : out STD_LOGIC_VECTOR (4 downto 0);
			  RF_WB_value:out  STD_LOGIC_VECTOR (31 downto 0)
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



signal S_reg2 : STD_LOGIC_VECTOR (4 downto 0); 
signal S_wrData : STD_LOGIC_VECTOR (31 downto 0);


begin

ImmEX: Immed_extender
	PORT MAP (
				imm16		 => Instr(15 downto 0),
				extension => extension,
				shift16	 => shift16,
				--OUTPUTS 
				imm32	    => Immed 
				);

RF: register_file 
	PORT MAP ( 	
					Ard1  => Instr(25 downto 21),	--rs
					Ard2  => S_reg2,					--rd or rt
					Awr   =>	RF_AWR_in,
					Dout1 => RF_A,
					Dout2 => RF_B,
					Din   => S_wrData,
					WrEn  => RF_WrEn,    				
					Clk   => Clk,
					reset => reset						
					);

MUX_1: Mux10To5
	PORT MAP (
					Mux_in_A => Instr(15 downto 11),		--'0' rt
					Mux_in_B => Instr(20 downto 16),		--'1' rd
					Mux_sel  => RF_B_sel,
					Mux_out  => S_reg2
					);

MUX_2: mux_2to1_32bit
	PORT MAP (
				 A 	 => ALU_out,  --'0'
				 B 	 => MEM_out,	--'1'
				 SEL => RF_WrData_sel,
				 X   => S_wrData
				);
					
RF_AWR_OUT<=Instr(20 downto 16);
RS <= Instr(25 downto 21);
RT	<= Instr(15 downto 11);
RF_WB_value <= S_wrData;
end Structural;