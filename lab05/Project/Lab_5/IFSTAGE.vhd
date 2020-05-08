library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  PC_plus4: out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is
------------------------------------------------- COMPONENTS ---------------------------------------------------

component Incrementor is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_2to1_32bit is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component;

------------------------------------------------- SIGNALS ---------------------------------------------------
signal s_adder_out : STD_LOGIC_VECTOR (31 downto 0);
signal s_incrementor_out : STD_LOGIC_VECTOR (31 downto 0);
signal s_Mux_out : STD_LOGIC_VECTOR (31 downto 0);
signal s_PC_out : STD_LOGIC_VECTOR (31 downto 0);

begin
	PC_REG : regi port map (-- FINAL
								clk => Clk,
								Data => s_Mux_out,
								Dout => s_PC_out,
								WE => PC_LdEn,
								reset => Reset
								);

	INCR : Incrementor port map (--FINAL
								A => s_PC_out,
								X => s_incrementor_out
								);
								
	MUX : mux_2to1_32bit port map (--FINAL
								A => s_incrementor_out,
								B => PC_Immed,
								X => s_Mux_out,	
								SEL => PC_sel
								);

	PC <= s_PC_out;
	PC_plus4<=s_incrementor_out;
end Structural;