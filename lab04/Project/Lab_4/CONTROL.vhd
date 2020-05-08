library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity CONTROL is
    Port ( instructions : in  STD_LOGIC_VECTOR (31 downto 0);
			  zero : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ALUctr : out  STD_LOGIC_VECTOR(3 downto 0);
           Extop : out  STD_LOGIC;
			  RF_WrData_sel  : out STD_LOGIC_VECTOR(1 downto 0);
           Rb_RF_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC;
           RF_WrEn : out  STD_LOGIC;
			  ByteEnable : out STD_LOGIC;
			  MemWr : out STD_LOGIC;
			  shift16: out std_logic;
			  ALUSrcB :out std_logic_vector(1 downto 0);
			  ALUSrcA:out std_logic;
			  PC_LdEn_cond: out std_logic;
			  PC_source : out STD_LOGIC_VECTOR(1 downto 0);
			  IRWrite: out std_logic;
			  address_range : in std_logic;
			  CAUSEwrite : out std_logic;
			  intCause : out std_logic;
			  EPCwrite: out std_logic
         );
end CONTROL;

architecture Behavioral of CONTROL is

type stateS is (FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WRITEBACK, MEM_WRITE, R_EXECUTE, R_WRITE_BACK, BRANCH, I_EXECUTE, I_WRITE_BACK, JUMP,ILLEGAL_INSTR,ADDR_RANGE);
signal curS,nextS : states;
type op_state is (Load,Store,r_type, i_type, branch,j,fbranch,illeADDR);
signal OP : op_state;
signal li, lui, addi, nandi, ori, b, beq, bne, lb, sb,lw,sw,Rtype,jump_epc: std_logic ;
signal opcode: std_logic_vector(5 downto 0);
signal imm16 :std_logic_vector(15 downto 0);
signal addr :std_logic_vector(15 downto 0);
signal func:std_logic_vector(5 downto 0); 
signal rtypeFuncs:std_logic; 
signal existing_func:std_logic; 

begin

imm16 <= instructions(15 downto 0);


-------------------------------------------------------- COMMANDS CODING ----------------------------------------------------
commands: process(instructions,opcode,func,rtypeFuncs )
	begin 
		opcode <= instructions(31 downto 26);
		func   <= instructions(5 downto 0);
		rtypeFuncs <= (((not func(3)) and (not func(2))) or ((func(3)) and (not func(1))) or ((not func(1)) and (not func(0))) or ((not func(2)) and (not func(0))));
		existing_func <= rtypeFuncs or ((not func(5)) and (not func(4)) and (not func(3)) and (not func(2)) and (func(1)) and (not func(0)));
		-----------------------------------------------------	  R-TYPES   ------------------------------------------------------ 
		Rtype 	<= 	  opcode(5)	 and(not opcode(4))  and(not opcode(3)) and(not opcode(2)) and(not opcode(1)) and(not opcode(0));
		-----------------------------------------------------   I-TYPES   -------------------------------------------------------
		li    	<=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)	 and (not opcode(2))and (not opcode(1))and (not opcode(0)); 			--(111000)
		lui		<=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)  and (not opcode(2))and (not opcode(1))and      opcode(0) ;				--(111001)
		addi		<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and (not opcode(0));				--(110000)
		nandi		<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and      opcode(1) and (not opcode(0));				--(110010)
		ori		<=	     opcode(5)	 and	   opcode(4) 	and(not opcode(3)) and (not opcode(2))and      opcode(1) and      opcode(0) ;				--(110011)
		-----------------------------------------------------	 BRANCHES  ---------------------------------------------------------
		b			<=	     opcode(5)	 and	   opcode(4) 	and	  opcode(3)	 and      opcode(2) and      opcode(1) and      opcode(0) ;				--(111111)
		beq		<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and (not opcode(0));				--(000000)
		bne		<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and (not opcode(1))and      opcode(0) ;				--(000001)
		-----------------------------------------------------	  STORE    ---------------------------------------------------------
		sw			<= (not opcode(5)) and	  opcode(4) 	and	  opcode(3)  and      opcode(2) and      opcode(1) and      opcode(0) ;				--(011111)
		sb			<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and      opcode(2) and      opcode(1) and      opcode(0) ;				--(000111)
		-----------------------------------------------------    LOAD    ---------------------------------------------------------
		lw			<=	(not opcode(5)) and(not opcode(4))	and	  opcode(3)  and      opcode(2) and      opcode(1) and      opcode(0) ;				--(001111)
		lb			<=	(not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and      opcode(1) and      opcode(0) ;				--(000011)
		jump_epc	<= (not opcode(5)) and(not opcode(4))	and(not opcode(3)) and (not opcode(2))and      opcode(1) and (not opcode(0)) ;		   --(000010)
end process;



-------------------------------------------------------- OP CODING ----------------------------------------------------

OP_ST: process(li, lui, addi, nandi, ori, b, beq, bne, lb, sb,lw,sw,Rtype,zero,jump_epc)
	begin
		if (lb or lw)='1' then 
			OP <= Load;
		elsif (sb or sw)='1' 	then 
			OP <= Store;
		elsif Rtype='1' 	then 
			OP <= r_type;
		elsif (li or lui or addi or nandi or ori)='1' 	then 
			OP <= i_type;
		elsif (b or  beq or bne) ='1' then 
			OP <=branch ;
		elsif (jump_epc = '1') then 
			OP <= j;
		else
			OP <= illeADDR;
		end if;
	end process; 	
	
	
-----------------------------------------------------------------------------------------
	--S0 : FETCH
	--S1 : DECODE
	
	--(LOAD OR STORE WORD/BYTE)
	--S2 : MEM_ADR
	--S3 : MEM_READ
	--S4 : MEM_WRITEBACK
	--S5 : MEM_WRITE	
	
	--(R TYPE EXECUTION)
	--S6 : R_EXECUTE
	--S7 : R_WRITE_BACK
	
	--(BRANCHES)
	--S8 : BRANCH
	
	--(I TYPE EXECUTION)
	--S9 : I_EXECUTE
	--S10: I_WRITE_BACK
	
	--(J TYPE EXECUTION)
	--S11: JUMP
	
-------------------------------------------------------- FSM BEHAVE ----------------------------------------------------
FSM_BEH: Process(curS,OP,instructions,address_range,existing_func)
	Begin
		case curs is 
			when FETCH =>
				nextS <= DECODE;
			when DECODE =>
				if 	OP = Load 	 	then nextS <= MEM_ADR;
				elsif OP = Store   	then nextS <= MEM_ADR;	
				elsif OP = r_type  	then
					if existing_func = '1'	then 
						nextS <= R_EXECUTE;	
					else	
						nextS <= ILLEGAL_INSTR;
					end if;
				elsif OP = i_type  	then nextS <= I_EXECUTE;
				elsif OP = branch  	then nextS <= BRANCH;
				elsif OP = j       	then nextS <= JUMP;
				elsif OP = illeADDR  then nextS <= ILLEGAL_INSTR;
				else 						  nextS <= curS ;
				end if;
			when MEM_ADR =>
				if 	OP = Load 	then nextS <= MEM_READ;	
				elsif OP = Store  then nextS <= MEM_WRITE;
				else 						  nextS <= curS ;
				end if;
			when MEM_READ =>
				if address_range='0' then
					nextS <= MEM_WRITEBACK;
				else 
					nextS <= ADDR_RANGE;
				end if;	
			when MEM_WRITEBACK =>
				nextS <= FETCH;
			when MEM_WRITE =>
				nextS <= FETCH;
			when R_EXECUTE =>
				nextS <= R_WRITE_BACK;
			when R_WRITE_BACK =>
				nextS <= FETCH;
			when BRANCH =>
				nextS <= FETCH;	
			when I_EXECUTE =>
				nextS <= I_WRITE_BACK;
			when I_WRITE_BACK =>
				nextS <= FETCH;
			when JUMP =>
				nextS <= FETCH;
			when others => 
				nextS <= FETCH;
		end case;
	end process; 

-------------------------------------------------------- FSM outputs per STATE ----------------------------------------------------
FSM_outputs:process(curS,zero)
	begin
		if (curS = FETCH)  then							-- FETCH
			ALUctr  <= "0000"; --add
			Extop <= '0';
			Rb_RF_sel <= '0';
			PC_LdEn <= '1';
			ALUSrcA <= '0';
			ALUSrcB <= "01";
			PC_source <="00";
			IRWrite <= '1';
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = DECODE)  then					-- DECODE
			ALUctr  <= "0000"; --add
			ALUSrcA <= '0';
			ALUSrcB <= "11";
			PC_source <="00";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = ILLEGAL_INSTR)  then					-- ILLEGAL_INSTR
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <= "10";
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '0';
			------------------
			CAUSEwrite <= '1';
			intCause <= '0';
			EPCwrite<= '1';
			PC_source <="11";
			PC_LdEn <= '1';
			ALUctr  <= "0001"; --add
			ALUSrcA <= '0';
			ALUSrcB <= "01";
		elsif (curS = MEM_ADR) then					-- MEM_ADR
			
			ALUctr  <= "0000"; --add
			ALUSrcA <= '1';
			ALUSrcB <= "10";
			PC_source <="00";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '1';
			RF_WrData_sel <= "00";
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '1';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = R_EXECUTE)  then				-- R_EXECUTE
			ALUctr <= instructions(3 downto 0);
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="00";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <="00";
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = BRANCH) then 					-- BRANCH
			ALUctr <= "0001";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="00";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '1';
			RF_WrData_sel <= "00";
			MemWr <= '0';
			RF_WrEn <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '1';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
			PC_LdEn_cond <=( b or (beq and zero) or (bne and (not zero)));
		elsif (curS = I_EXECUTE) then 				-- I_EXECUTE
			ALUSrcA <= '1';
			ALUSrcB <= "10";
			if(li or lui)='1' then 
				ALUctr <= "1111";
			else
				ALUctr <= opcode(3 downto 0) ;
			end if;
			PC_source <="00";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <= "00";	
			MemWr <= '0';	
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			ByteEnable <= '0';
			shift16 <= lui;
			Extop <= li or addi ;
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = JUMP) then 					-- JUMP
			ALUctr <= "1111";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="10";
			PC_LdEn <= '1';
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <= "00";
			MemWr <= '0';
			RF_WrEn <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '0';
			PC_LdEn_cond <='0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		elsif (curS = MEM_WRITE) then 				-- MEM_WRITE
			ALUctr <= "0001";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="01";
			PC_LdEn <= '0';
			IRWrite <= '0';	
			Rb_RF_sel <= '1';	
			RF_WrData_sel <= "00";
			MemWr <= '1';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= sb;
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
			Extop <= '0';
		elsif (curS = R_WRITE_BACK) then 			-- R_WRITE_BACK
			ALUctr <= "0001";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="01";
			PC_LdEn <= '0';
			IRWrite <= '0';	
			Rb_RF_sel <= '1';	
			RF_WrData_sel <= func(5 downto 4);
			MemWr <= '1';	
			RF_WrEn <= '1';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
			Extop <= '0';
		elsif (curS = I_WRITE_BACK) then 			-- I_WRITE_BACK
			ALUctr <= "0001";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="01";
			PC_LdEn <= '0';
			IRWrite <= '0';	
			Rb_RF_sel <= '1';	
			RF_WrData_sel <= "11";
			MemWr <= '0';	
			RF_WrEn <= '1';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
			Extop <= '0';
		elsif (curS = ADDR_RANGE)  then					-- ADDR_RANGE
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <= "10";
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <= '0';
			Extop <= '0';
			------------------
			CAUSEwrite <= '1';
			intCause <= '1';
			EPCwrite<= '1';
			PC_source <="11";
			PC_LdEn <= '1';
			ALUctr  <= "0001"; --add
			ALUSrcA <= '0';
			ALUSrcB <= "01";
		elsif (curS = MEM_WRITEBACK) then 			-- MEM_WRITEBACK
			ALUctr <= "0001";
			ALUSrcA <= '1';
			ALUSrcB <= "00";
			PC_source <="01";
			PC_LdEn <= '0';
			IRWrite <= '0';
			Rb_RF_sel <= '0';
			RF_WrData_sel <= "01";
			MemWr <= '0';
			RF_WrEn <= '1';
			PC_LdEn_cond <= '0';
			shift16 <= '0';
			ByteEnable <=  lb;
			Extop <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		else													-- IN every other state, all enables are off
			ALUctr <= "1111";
			PC_LdEn <= '0';
			IRWrite <= '0';
			MemWr <= '0';
			RF_WrEn <= '0';
			PC_LdEn_cond <= '0';
			Extop <= '0';
			CAUSEwrite <= '0';
			intCause <= '0';
			EPCwrite<= '0';
		end if;
	end process;

-------------------------------------------------------- FSM SYNCHRONISATION ----------------------------------------------------
--Reset initialize the FSM to FETCH state.
fsm_synch: process(clk, reset)
	Begin 
		if reset = '1' then 
			curS <= FETCH;
		elsif rising_edge(clk) then
			curS <= nextS; 	
		end if;
	end process;

end Behavioral;


