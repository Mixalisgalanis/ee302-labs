library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Top_module;

architecture Behavioral of Top_module is

-------------------------------- RAM ------------------------------------

component RAM is 
	port ( 
			clk     : in std_logic;         
			inst_addr : in std_logic_vector(10 downto 0);         
			inst_dout : out std_logic_vector(31 downto 0);         
			data_we     : in std_logic;         
			data_addr     : in std_logic_vector(10 downto 0);         
			data_din     : in std_logic_vector(31 downto 0);         
			data_dout  : out std_logic_vector(31 downto 0));     
end component; 
  
-----------------------------	PROCESSOR ---------------------------------

component processor is
    Port( 
			clk : in  STD_LOGIC;
         reset : in  STD_LOGIC; 
			inst_addr : out std_logic_vector(10 downto 0);         
			inst_dout : in std_logic_vector(31 downto 0);         
			data_we     : out std_logic;
			IRWrite     : out std_logic;         
			data_addr     : out std_logic_vector(10 downto 0);         
			data_din     : out std_logic_vector(31 downto 0);         
			data_dout  : in std_logic_vector(31 downto 0));     
end component;

-----------------------------	REGISTERS ---------------------------------

component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component;

signal s_instructions_pre : std_logic_vector(31 downto 0);
signal s_instructions_post : std_logic_vector(31 downto 0);
signal s_inst_addr :  std_logic_vector(10 downto 0); 
signal s_data_addr :  std_logic_vector(10 downto 0); 
signal s_data_out_pre :  std_logic_vector(31 downto 0);
signal s_data_out_post :  std_logic_vector(31 downto 0);
signal s_data_din :  std_logic_vector(31 downto 0);
signal s_MemWr : std_logic;
signal s_IRWrite : std_logic;

begin

RM :RAM  
	PORT MAP(   
				clk       => clk,    
				inst_addr => s_inst_addr,            
				inst_dout => s_instructions_pre,         
				data_we   => s_MemWr,    
				data_addr => s_data_addr,        
				data_din  => s_data_din,        
				data_dout => s_data_out_pre
				);

IR : regi
	PORT MAP(
					clk => clk,
					reset => reset,
					Data => s_instructions_pre,
					Dout => s_instructions_post,
					We => s_IRWrite
				);

MDR : regi
	PORT MAP(
					clk => clk,
					reset => reset,
					Data => s_data_out_pre,
					Dout => s_data_out_post,
					We => '1'
				);

PROC :processor
	PORT MAP(   
				clk       => clk,    
				reset		 => reset,
				inst_addr => s_inst_addr,            
				inst_dout => s_instructions_post,         
				data_we   => s_MemWr,    
				data_addr => s_data_addr,        
				data_din  => s_data_din,        
				data_dout => s_data_out_post,
				IRWrite 	 => s_IRWrite
				);

end Behavioral;

