library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEMSTAGE is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_MEM_NewAddr : out  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE;

architecture Structural of MEMSTAGE is

component AddressIncrementor is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end component; 

begin
Incrementor : AddressIncrementor 
	PORT MAP (
					A => ALU_MEM_Addr,
					X => ALU_MEM_NewAddr
					);
															
end Structural;