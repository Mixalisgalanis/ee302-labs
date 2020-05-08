library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEMORY is
	Port ( PC_sel : in STD_LOGIC;
			 PC_LdEn : in STD_LOGIC;
			 ALU_MEM_Addr : in STD_LOGIC_VECTOR (31 downto 0);
			 Reset : in STD_LOGIC;
			 Clk : in STD_LOGIC;
			 data_din : in STD_LOGIC_VECTOR (31 downto 0);
			 data_we : in STD_LOGIC;
			 PC_Immed : in STD_LOGIC_VECTOR (31 downto 0);
			 inst_dout : out STD_LOGIC_VECTOR (31 downto 0);
			 data_dout : out STD_LOGIC_VECTOR (31 downto 0));
end MEMORY;

architecture Structural of MEMORY is
------------------------------------------------- COMPONENTS ---------------------------------------------------
component MEMSTAGE is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_MEM_NewAddr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component RAM is     
	port (         
			clk : in std_logic;         
			inst_addr : in std_logic_vector(10 downto 0);         
			inst_dout : out std_logic_vector(31 downto 0);         
			data_we : in std_logic;         
			data_addr : in std_logic_vector(10 downto 0);         
			data_din : in std_logic_vector(31 downto 0);         
			data_dout : out std_logic_vector(31 downto 0));     
end component;

------------------------------------------------- SIGNALS ---------------------------------------------------
signal s_pc_out : std_logic_vector (31 downto 0);
signal s_mem_stage_out : std_logic_vector (31 downto 0);
begin

	IF_STAGE	: IFSTAGE port map (
										PC_Immed => PC_Immed,
										PC_sel => PC_sel,
										PC_LdEn => PC_LdEn,
										Reset => Reset,
										Clk => Clk,
										PC => s_pc_out
										);
	
	RAM_MEM : RAM port map (
										clk => Clk,
										inst_addr => s_pc_out (12 downto 2),
										inst_dout => inst_dout,
										data_we => data_we,
										data_addr => s_mem_stage_out(12 downto 2),
										data_din => data_din,
										data_dout => data_dout
										);

	MEM_STAGE	: MEMSTAGE port map (
										ALU_MEM_Addr => ALU_MEM_Addr,
										ALU_MEM_NewAddr => s_mem_stage_out
										);
	
end Structural;

