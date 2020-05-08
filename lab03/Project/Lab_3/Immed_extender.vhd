----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:57:41 02/28/2019 
-- Design Name: 
-- Module Name:    Immed_extender - Behavioral 
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
Use ieee.numeric_std.all;

entity Immed_extender is
    Port (	
				imm16 : in  STD_LOGIC_VECTOR (15 downto 0);
				shift16: in std_logic;
				extension: in std_logic;
				shifting : in STD_LOGIC;
				imm32 : out  STD_LOGIC_VECTOR (31 downto 0));
end Immed_extender;

architecture Behavioral of Immed_extender is

begin
im32out: process(shift16,imm16,extension,shifting)
	begin
		if (shift16 = '1') then 
			imm32 <= STD_LOGIC_VECTOR(shift_left(signed((31 downto 16 => imm16(15)) & imm16),16));
		elsif (extension = '1') then 
			if (shifting = '1') then 
				imm32 <= STD_LOGIC_VECTOR(shift_left(signed((31 downto 16 => imm16(15)) & imm16),2));
			else 
				imm32 <= (31 downto 16 => imm16(15)) & imm16;
			end if;
		else
			if (shifting = '1') then 
				imm32 <= STD_LOGIC_VECTOR(shift_left(signed((31 downto 16 => '0') & imm16),2));
			else 
				imm32 <=(31 downto 16 => '0') & imm16;
			end if;
		end if;
	end process;
end Behavioral;









