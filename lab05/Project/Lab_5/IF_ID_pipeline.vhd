----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:31:55 04/14/2019 
-- Design Name: 
-- Module Name:    IF_ID_pipeline - Behavioral 
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

entity IF_ID_pipeline is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  we: in STD_LOGIC;
			  inst_in: in STD_LOGIC_VECTOR(31 downto 0);
			  inst_out: out STD_LOGIC_VECTOR(31 downto 0);
			  pc_in: in STD_LOGIC_VECTOR(31 downto 0);
			  pc_out: out STD_LOGIC_VECTOR(31 downto 0)
			  );
end IF_ID_pipeline;

architecture Behavioral of IF_ID_pipeline is

Component regi is
    Port ( clk : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
			  reset : in  STD_LOGIC);
end Component;


begin
instruction: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> inst_in,
						Dout 	=> inst_out,
						WE		=> we,
						reset => reset
						);

PC_pls4: regi 
		PORT MAP ( 	clk 	=> clk,
						Data 	=> pc_in,
						Dout 	=> pc_out,
						WE		=> we,
						reset => reset
						);

end Behavioral;

