--------------------------------------------	FINAL (testbench missing)	--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in  STD_LOGIC;
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


component MUX64TO32 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;

signal s_AluInB: STD_LOGIC_VECTOR (31 downto 0);

begin

AL: ALU 
    Port map( 
					A 		 => RF_A,
					B 		 => s_AluInB,
					Op 	 => ALUctr,
					Output => ALU_out,
					Zero   => zero
					);

MUX_2: MUX64TO32
	PORT MAP (
					A 	 => RF_B,
					B 	 => Immed,
					SEL => ALUSrc,
					X   => s_AluInB
					);


end Structural;

