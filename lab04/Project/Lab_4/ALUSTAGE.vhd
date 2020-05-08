--------------------------------------------	FINAL (testbench missing)	--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
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


component mux_4to1_32bit is
	 Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0); 
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  D : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR(1 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;


signal s_srcA: STD_LOGIC_VECTOR (31 downto 0);
signal s_srcB: STD_LOGIC_VECTOR (31 downto 0);
signal s_AluInB: STD_LOGIC_VECTOR (31 downto 0);

begin

AL: ALU 
    Port map( 
					A 		 => s_srcA,
					B 		 => s_srcB,
					Op 	 => ALUctr,
					Output => ALU_out,
					Zero   => zero
					);
-- MULTIPLEXER SRCB(
-- ALUSrcA = 0 -> loads PC
-- ALUSrcA = 1 -> loads RF_B

srcA: mux_2to1_32bit
	PORT MAP (
					A 	 => PC,
					B 	 => RF_A,
					SEL => ALUSrcA,
					X   => s_srcA
					);

-- MULTIPLEXER SRCB(
-- ALUSrcB = 00 -> loads RF_B
-- ALUSrcB = 01 -> loads 4
-- ALUSrcB = 10 -> loads immed (sign extended or zero filled)
-- ALUSrcB = 11 -> loads immed shifted left by 2
srcB: mux_4to1_32bit
	PORT MAP (
					A 	 => RF_B,
					B 	 => X"00000004",
					C	 => Immed,
					D	 => Immed_sft2,
					SEL => ALUSrcb,
					X   => s_srcB
					);


end Structural;

