
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MEM_WB_pipeline is
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
end MEM_WB_pipeline;

architecture Behavioral of MEM_WB_pipeline is

component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component ;


signal s_addr_dout: STD_LOGIC_VECTOR(31 downto 0);
signal s_addr_in: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_out: STD_LOGIC_VECTOR(31 downto 0);
signal s_MEM_WB_SIG_in: STD_LOGIC_VECTOR(31 downto 0);

begin

s_MEM_WB_SIG_in(31 downto 2)<= (others=>'0');
s_MEM_WB_SIG_in(1 downto 0)<= MEM_WB_SIG_IN;
						
EX_MEM_SIG: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_MEM_WB_SIG_in,
						Dout 	=> s_MEM_WB_SIG_out,
						WE		=> we,
						reset => reset
						);
memToReg <=s_MEM_WB_SIG_out(0);
RF_we 	<=s_MEM_WB_SIG_out(1);

------------------------------------------------------------
ALU_out: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> ALU_out_in,
						Dout 	=> ALU_out_out,
						WE		=> we,
						reset => reset
						);

RF_B: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> Meme_out_in,
						Dout 	=> Meme_out_out,
						WE		=> we,
						reset => reset
						);
						
----------------------------------------------------							
s_addr_in(31 downto 5)<= (others=>'0');
s_addr_in(4 downto 0)<= reg_dst_in;
						
reg_dst: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> s_addr_in,
						Dout 	=> s_addr_dout,
						WE		=> we,
						reset => reset
						);
						
reg_dst_out<=s_addr_dout(4 downto 0);
----------------------------------------------------
end Behavioral;

