----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:40 03/06/2019 
-- Design Name: 
-- Module Name:    processor - Behavioral 
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


entity processor is
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
end processor;


architecture Behavioral of processor is

component CONTROL is
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
end component;

component Datapath is
    Port( 
			clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			zero : out STD_LOGIC;
			--Memory input signals 
			instructions : in std_logic_vector(31 downto 0);  
			instr_address :out std_logic_vector(10 downto 0);
			data_dout : in std_logic_vector(31 downto 0);  
			data_addr : out std_logic_vector(10 downto 0); 
			data_din  : out std_logic_vector(31 downto 0); 
			--contol unit signals
			CU_ALUctr : in std_logic_vector(3 downto 0);
			CU_ALUSrcA : in STD_LOGIC;
			CU_ALUSrcB : in STD_LOGIC_VECTOR(1 downto 0);
			CU_RF_WrEn : in STD_LOGIC;
			CU_RF_WrData_sel  : in STD_LOGIC_VECTOR(1 downto 0);
			CU_PC_LdEn : in STD_LOGIC;
			CU_PC_LdEn_cond : in STD_LOGIC;
			CU_RF_B_sel : in STD_LOGIC;
			CU_Exten : in STD_LOGIC;
			CU_ByteEnable : in STD_LOGIC;
			CU_PC_source : in STD_LOGIC_VECTOR(1 downto 0);
			CU_CAUSEwrite : in std_logic;
			CU_intCause : in std_logic;
			CU_EPCwrite : in std_logic;
			shift16 : in std_logic;
			address_range : out std_logic
		  );
end component;

signal s_zero : std_logic;
signal s_ALUctr : std_logic_vector(3 downto 0);
signal s_extop : std_logic;
signal s_RF_WrData_sel : std_logic_vector(1 downto 0);
signal s_Rb_RF_sel : std_logic;
signal s_PC_LdEn : std_logic;
signal s_RF_WrEn : std_logic;
signal s_shift : std_logic;
signal s_shift16 : std_logic;
signal s_ByteEnable : std_logic;
signal s_PC_LdEn_cond : std_logic;
signal s_ALUSrcA : std_logic;
signal s_ALUSrcB : std_logic_vector(1 downto 0);
signal s_PC_source : std_logic_vector(1 downto 0);
signal s_CAUSEwrite : std_logic;
signal s_intCause : std_logic;
signal s_EPCwrite : std_logic;
signal s_address_range : std_logic;

begin

DTPATH: Datapath 
   PORT MAP( 
				clk   => clk,
				reset => reset,
--				Memory input signals 
				instructions => inst_dout, 
				instr_address => inst_addr,
				data_dout => data_dout,  
				data_addr => data_addr,
				data_din  => data_din,
				zero => s_zero,
--				control unit signals			
				CU_ALUctr => s_ALUctr,
				CU_ALUSrcA => s_ALUSrcA,
				CU_ALUSrcB => s_ALUSrcB,
				CU_RF_WrEn => s_RF_WrEn,
				CU_RF_WrData_sel => s_RF_WrData_sel,
				CU_PC_LdEn => s_PC_LdEn,
				CU_PC_LdEn_cond => s_PC_LdEn_cond,
				CU_RF_B_sel => s_Rb_RF_sel,
				CU_Exten => s_extop,
				CU_ByteEnable => s_ByteEnable,
				shift16 => s_shift16,
				CU_PC_source => s_PC_source,	
				CU_CAUSEwrite => s_CAUSEwrite,
				CU_intCause => s_intCause,
				CU_EPCwrite => s_EPCwrite,
				address_range => s_address_range
				);

				
CNTRL:  CONTROL 
   PORT MAP( 
				instructions =>  inst_dout,
				zero 		=> s_zero,
				clk 		=> clk,
				reset 	=> reset,
				MemWr 	=>	data_we,
				IRWrite 	=> IRWrite,
--				datapath enables
				ALUctr 	=> s_ALUctr,
				ALUSrcA	=> s_ALUSrcA,
				ALUSrcB 	=> s_ALUSrcB,
			   RF_WrEn 	=>	s_RF_WrEn,
				RF_WrData_sel => s_RF_WrData_sel,
				PC_LdEn	=>	s_PC_LdEn,
				PC_LdEn_cond => s_PC_LdEn_cond,
				Rb_RF_sel=> s_Rb_RF_sel,
				Extop 	=> s_extop,
				ByteEnable=> s_ByteEnable,
				shift16 	=> s_shift16,
				PC_source => s_PC_source,
				CAUSEwrite => s_CAUSEwrite,
				intCause => s_intCause,
				EPCwrite => s_EPCwrite,
				address_range => s_address_range
			  );
			  
end Behavioral;

