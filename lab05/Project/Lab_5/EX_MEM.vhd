----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:23:54 04/14/2019 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX_MEM_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           we : in  STD_LOGIC;
			  pc_in: in STD_LOGIC_VECTOR (31 downto 0);
			  pc_out:out STD_LOGIC_VECTOR (31 downto 0);
			  zero_in:in STD_LOGIC;
			  zero_out:out STD_LOGIC;
			  Immed_in:in STD_LOGIC_VECTOR (31 downto 0);
			  Immed_out:out STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_in:in STD_LOGIC_VECTOR (31 downto 0);
			  RF_B_out:out STD_LOGIC_VECTOR (31 downto 0);
			  reg_dst_in:in STD_LOGIC_VECTOR (4 downto 0);
			  reg_dst_out:out STD_LOGIC_VECTOR (4 downto 0)
			  );
end EX_MEM_pipeline;

architecture Behavioral of EX_MEM_pipeline is

component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset: in STD_LOGIC
			  );
end component ;

component  register_1bit is
    Port ( clk : in  STD_LOGIC;
           data : in  STD_LOGIC;
           dout : out  STD_LOGIC;
           we : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component ;

begin






-------------------------- mapping for datapath signals--------------------------------

PC_pls4:	regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> pc_in,
						Dout 	=> pc_out,
						WE		=> we,
						reset => reset
						);
						
zero: register_1bit 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> zero_in,
						Dout 	=> zero_out,
						WE		=> we,
						reset => reset
						);

ALU_out: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> Immed_in,
						Dout 	=> Immed_out,
						WE		=> we,
						reset => reset
						);

RF_B: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> RF_B_in,
						Dout 	=> RF_B_out,
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

