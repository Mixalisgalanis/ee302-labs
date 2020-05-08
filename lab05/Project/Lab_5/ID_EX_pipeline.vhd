
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EX_pipeline is
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
end ID_EX_pipeline;

architecture Behavioral of ID_EX_pipeline is

Component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset : in  STD_LOGIC);
end Component;

component  register_1bit is
    Port ( clk : in  STD_LOGIC;
           data : in  STD_LOGIC;
           dout : out  STD_LOGIC;
           we : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component ;

signal s_addr_dout: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_RT_dout: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_RT_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_RS_dout: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_RS_in: STD_LOGIC_VECTOR(31 downto 0);

signal s_CU_ALUctr_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_CU_ALUctr_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_EX_MEM_SIG_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_EX_MEM_SIG_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_reset: std_logic;
begin


---------------------CONTROL-----------------------

----------------------------------------------------						
s_CU_ALUctr_in(31 downto 4)<= (others=>'0');
s_CU_ALUctr_in(3 downto 0)<= CU_ALUctr_in;
						
ALU_CTRL: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_CU_ALUctr_in,
						Dout 	=> s_CU_ALUctr_out,
						WE		=> we,
						reset => s_reset
						);
CU_ALUctr_out<=s_CU_ALUctr_out(3 downto 0);

----------------------------------------------------
ALU_SRC: register_1bit 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> CU_ALU_src_in,
						Dout 	=> CU_ALU_src_out,
						WE		=> we,
						reset => s_reset
						);

-------------------EX_MEM_SIG-----------------------	
					
s_EX_MEM_SIG_in(31 downto 5)<= (others=>'0');
s_EX_MEM_SIG_in(4 downto 0)<= EX_MEM_SIG_IN;
						
EX_MEM_SIG: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_EX_MEM_SIG_in,
						Dout 	=> s_EX_MEM_SIG_out,
						WE		=> we,
						reset => s_reset
						);
EX_MEM_SIG_OUT<=s_EX_MEM_SIG_out(4 downto 0);

------------------MEM_WB_SIG---------------------	
					
s_MEM_WB_SIG_in(31 downto 2)<= (others=>'0');
s_MEM_WB_SIG_in(1 downto 0)<= MEM_WB_SIG_IN;
						
MEM_WB_SIG: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_MEM_WB_SIG_in,
						Dout 	=> s_MEM_WB_SIG_out,
						WE		=> we,
						reset => s_reset
						);
MEM_WB_SIG_OUT<=s_MEM_WB_SIG_out(1 downto 0);



---------------------DATAPATH-----------------------

----------------------------------------------------
PC_pls4:	regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> pc_in,
						Dout 	=> pc_out,
						WE		=> we,
						reset => '0'
						);
----------------------------------------------------						
RF_A: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> RF_A_in,
						Dout 	=> RF_A_out,
						WE		=> we,
						reset => '0'
						);
----------------------------------------------------						
RF_B: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> RF_B_in,
						Dout 	=> RF_B_out,
						WE		=> we,
						reset => '0'
						);
----------------------------------------------------
immmed: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> Immed_in,
						Dout 	=> Immed_out,
						WE		=> we,
						reset => '0'
						);


----------------------------------------------------						
s_addr_in(31 downto 5)<= (others=>'0');
s_addr_in(4 downto 0)<= reg_dst_in;
						
reg_dst: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_addr_in,
						Dout 	=> s_addr_dout,
						WE		=> we,
						reset => '0'
						);
reg_dst_out<=s_addr_dout(4 downto 0);

----------------------------------------------------						
s_addr_RS_in(31 downto 5)<= (others=>'0');
s_addr_RS_in(4 downto 0)<= RS_in;
						
RS_add: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_addr_RS_in,
						Dout 	=> s_addr_RS_dout,
						WE		=> we,
						reset => '0'
						);
RS_out<=s_addr_RS_dout(4 downto 0);
----------------------------------------------------						
s_addr_RT_in(31 downto 5)<= (others=>'0');
s_addr_RT_in(4 downto 0)<= RT_in;
						
RT_add: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_addr_RT_in,
						Dout 	=> s_addr_RT_dout,
						WE		=> we,
						reset => '0'
						);
RT_out<=s_addr_RT_dout(4 downto 0);
----------------------------------------------------
rset: process(clk,reset)
	begin 
		if rising_edge(clk) then 
			s_reset <= reset ;
		else
			s_reset <= '0';
		end if;
	end process;
	

end Behavioral;

