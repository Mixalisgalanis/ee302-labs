
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Hazard_UNIT is
    Port ( ALU_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU_rt : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rt : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           MEM_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           WB_rd : in  STD_LOGIC_VECTOR (4 downto 0);
			  RG_dst: in STD_LOGIC_VECTOR(4 downto 0);
           RF_we_MEM : in  STD_LOGIC;
           RF_we_WB : in  STD_LOGIC;
           Forward_A : out  STD_LOGIC_VECTOR (1 downto 0);
           Forward_B : out  STD_LOGIC_VECTOR (1 downto 0);
			  memToReg : in std_logic;
			  ST_PC : out  STD_LOGIC;
			  ST_IF_ID : out  STD_LOGIC;
			  CLR_ID_EX : out  STD_LOGIC
			  );
end Hazard_UNIT;

architecture Behavioral of Hazard_UNIT is

begin

forwarding: process(RF_we_MEM,RF_we_WB,ALU_rs,ALU_rt,MEM_rd,WB_rd)
	begin
		if ((RF_we_MEM='1') and (MEM_rd /= "00000") and (MEM_rd = ALU_rs)) then   
			Forward_A <= "10";
		elsif ((RF_we_WB='1') and  (WB_rd /= "00000") and (WB_rd = ALU_rs)
					and not  ((RF_we_MEM='1') and (MEM_rd /= "00000")and (MEM_rd = ALU_rs))) then 
			Forward_A <= "01";
		else 	
			Forward_A <= "00";
		end if;
		
		if (((RF_we_MEM='1') and (MEM_rd /= "00000") and ((MEM_rd = ALU_rt) or (MEM_rd = RG_dst))))then   
			Forward_B <= "10";
		elsif ((((RF_we_WB='1') and  (WB_rd /= "00000") and ((WB_rd = ALU_rt) or (WB_rd = RG_dst)))
					and not ((RF_we_MEM='1') and (MEM_rd /= "00000") and ((MEM_rd = ALU_rt) or (MEM_rd = RG_dst))))) then 
			Forward_B <= "01";
		else 	
			Forward_B <= "00";
		end if;
	end process;

stalling: process(memToReg)
	begin 
	if (memToReg='1' and ((DEC_rs=RG_dst) or (DEC_rt=RG_dst) or (DEC_rd=RG_dst))) then 
		ST_PC 	<= '0';
		ST_IF_ID <= '0';
		CLR_ID_EX<= '1'; 
	else
		ST_PC 	<= '1';
		ST_IF_ID <= '1';
		CLR_ID_EX<= '0'; 
	end if;
	end process;
end Behavioral;

