
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_STD.ALL;


entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;


architecture Behavioral of ALU is



signal temp_out: STD_LOGIC_VECTOR (31 downto 0);
signal temp_A: STD_LOGIC_VECTOR (32 downto 0);
signal temp_B: STD_LOGIC_VECTOR (32 downto 0);
signal temp_carry: STD_LOGIC_VECTOR (32 downto 0);
signal temp_ovf: STD_LOGIC;
signaL temp_zero: STD_LOGIC;


begin


-- Output	
outpt: process(A,B,Op)
begin
	-- temp for output
	if Op="0000" then 
		temp_out <= A + B;
	elsif Op="0001" then 
		temp_out <= A - B;
	elsif Op="0010" then 
		temp_out <= A and B;
	elsif Op="0110" then 
		temp_out <= A nand B;
	elsif Op="0111" then 
		temp_out <= A or B;
	elsif Op="0100" then 
		temp_out <= NOT A;
	elsif Op="1000" then 
		temp_out <= STD_LOGIC_VECTOR(shift_right(signed(A),1));
	elsif Op="1001" then 
		temp_out <= STD_LOGIC_VECTOR(shift_left(unsigned(A),1));
	elsif Op="1010" then 
		temp_out <= STD_LOGIC_VECTOR(shift_right(unsigned(A),1));
	elsif Op="1100" then 
		temp_out <= STD_LOGIC_VECTOR(rotate_left(signed(A),1));
	elsif Op="1101" then 
		temp_out <= STD_LOGIC_VECTOR(rotate_right(signed(A),1));
	else 
		temp_out <="00000000000000000000000000000000";
	end if;
end process;
	
--Overflow	
overflow: process(A,B,Op,temp_out)
begin
	if Op="0000" then 
		--Overflow
		if A(31)='0' and  B(31)='0' and temp_out(31) = '1' then
			temp_ovf <='1';
		elsif A(31)='1' and  B(31)='1' and temp_out(31) = '0' then
			temp_ovf <='1';
		else
			temp_ovf <='0';
		end if;
	elsif Op="0001" then 
		--Overflow
		if A(31)='1' and  B(31)='0' and temp_out(31) = '0' then	--  (+)-(-)=(-) 
			temp_ovf <='1';
		elsif A(31)='0' and  B(31)='1' and temp_out(31) = '1' then	--  (-)-(+)=(+) 
			temp_ovf <='1';
		else
			temp_ovf <='0';
		end if;
	else 
		temp_ovf <='0';
	end if;
end process;
	

-- carry out	
carr: process(A,B,Op,temp_A,temp_B)
begin
	
	temp_A <= '0' & A;
	temp_B <= '0' & B;
	if Op="0000" then 
		temp_carry <= temp_A + temp_B;
	elsif Op="0001" then 
		temp_carry <=  not (temp_A - temp_B);
	else	
		temp_carry <= "000000000000000000000000000000000";
	end if;
end process;
	
-- zero	
Zr: process(temp_out)
begin
	if temp_out="00000000000000000000000000000000" then 
		temp_zero <= '1';
	else 
		temp_zero <= '0';
	end if;
end process;


	Ovf <= temp_ovf after 10ns;
	Output <= temp_out after 10ns;
	zero <= temp_zero after 10ns;
	Cout <= temp_carry(32) after 10ns;
	
end Behavioral;