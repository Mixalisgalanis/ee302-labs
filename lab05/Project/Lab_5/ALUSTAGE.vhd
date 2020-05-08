--------------------------------------------	FINAL (testbench missing)	--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
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
end ALUSTAGE;

architecture Structural of ALUSTAGE is

component ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC
			  );
end component;


component mux_2to1_32bit is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;

component Immed_shift is
    Port ( 	immed : in  STD_LOGIC_VECTOR (31 downto 0);
				shif_imm : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_4to1_32bit is
	 Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0); 
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  D : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR(1 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
			  
signal s_AluInB,s_shift_Immed: STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_A: STD_LOGIC_VECTOR (31 downto 0);
signal s_RF_B: STD_LOGIC_VECTOR (31 downto 0);

begin

Forw_RF_A:mux_4to1_32bit 
	 Port map( 
				  A 	=> RF_A,
              B 	=> RF_WB_value,
			     C 	=> ALU_out_mem,
			     D 	=> (others=>'0'),
              SEL => forward_A,
              X  	=> s_RF_A 
				 );

Forw_RF_B:mux_4to1_32bit 
	 Port map( 
				  A 	=> RF_B,
              B 	=> RF_WB_value,
			     C 	=> ALU_out_mem,
			     D 	=> (others=>'0'),
              SEL => forward_B,
              X 	=> s_RF_B
				 );			  
 
AL: ALU 
    Port map( 
					A 		 => s_RF_A,
					B 		 => s_AluInB,
					Op 	 => ALUctr,
					Output => ALU_out,
					Zero   => zero
					);

				
MUX_2: mux_2to1_32bit
	PORT MAP (
					A 	 => s_RF_B,
					B 	 => Immed,
					SEL => ALUSrc,
					X   => s_AluInB
					);


ADD: ALU 
    Port map( 
					A 		 => PC_plus4,
					B 		 => s_shift_Immed, 
					Op 	 => "0000",
					Output => PC_plus4_IM
					);

					
shift_IM:Immed_shift
	PORT MAP(
				immed =>Immed,
				shif_imm =>s_shift_Immed
				);

MEM_write_data <= s_RF_B;
end Structural;

