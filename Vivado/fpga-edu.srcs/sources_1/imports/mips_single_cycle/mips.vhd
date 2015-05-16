------------------------------------------------------------------
-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: mips_sc.vhd
-- Description: VHDL code to implment the structual design of
-- the MIPS Single-cycle processor. The top-level file connects
-- all the units together to complete functional processor.
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY mips_sc IS
	--Signals used for Simulation & Debug must be commented out if
	--implementing the UP2 Hardware implementation
	PORT( 
		PC : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		ALU_Result_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Read_Data1_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Read_Data2_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Write_Data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Write_Reg_out : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		Instruction_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Branch_out : OUT STD_LOGIC;
		Branch_NE_out : OUT STD_LOGIC;
		Zero_out : OUT STD_LOGIC;
		Jump_out : OUT STD_LOGIC;
		MemWrite_out : OUT STD_LOGIC;
		RegWrite_out : OUT STD_LOGIC;
		Clock, Reset : IN STD_LOGIC;
		led: out std_logic_vector(7 downto 0)
	);
	--Signals used for UP2 Board Implemntation
	--All signals here must be assigned to a pin on
	--the FLEX10K70 device.
	--PORT( D1_a, D1_b, D1_c, D1_d,
	-- D1_e, D1_f, D1_g,D1_pb : OUT STD_LOGIC;
	-- D2_a, D2_b, D2_c, D2_d,
	-- D2_e, D2_f, D2_g,D2_pb : OUT STD_LOGIC;
	-- Clock, Reset, PB : IN STD_LOGIC);
END mips_sc;
ARCHITECTURE structure of mips_sc IS
	--Declare all components/units/modules used that
	--makeup the MIPS Single-cycle processor.
	--COMPONENT debounce
	-- PORT ( Clock : IN STD_LOGIC;
	-- Pbutton : IN STD_LOGIC;
	-- Pulse : OUT STD_LOGIC);
	--END COMPONENT;
	COMPONENT instrfetch
		PORT( 
			enable: in std_logic;
			PC_Out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Add_Result : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			PC_plus_4_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Branch : IN STD_LOGIC;
			Branch_NE : IN STD_LOGIC;
			Zero : IN STD_LOGIC;
			Jump : IN STD_LOGIC;
			Jump_Address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Clock, Reset : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT operandfetch
		PORT (
			Read_Data_1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Read_Data_2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Write_Reg : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
			RegWrite : IN STD_LOGIC;
			RegDst : IN STD_LOGIC;
			ALU_Result : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			MemtoReg : IN STD_LOGIC;
			Read_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Sign_Extend : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Jump_Instr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Clock, Reset : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT controlunit IS
		PORT(
			Opcode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			RegDst : OUT STD_LOGIC;
			Branch : OUT STD_LOGIC;
			Branch_NE : OUT STD_LOGIC;
			MemRead : OUT STD_LOGIC;
			MemtoReg : OUT STD_LOGIC;
			ALU_Op : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			MemWrite : OUT STD_LOGIC;
			ALUSrc : OUT STD_LOGIC;
			RegWrite : OUT STD_LOGIC;
			Jump : OUT STD_LOGIC;
			Clock, Reset : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT execution IS
		PORT(
			Read_Data_1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Read_Data_2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Sign_Extend : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Jump_Instr : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Jump_Address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			ALUSrc : IN STD_LOGIC;
			Zero : OUT STD_LOGIC;
			ALU_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Funct_field : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			ALU_Op : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			Add_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			PC_plus_4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Clock, Reset : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT datamemory IS
		PORT(
			Read_Data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Write_Data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			MemRead : IN STD_LOGIC;
			MemWrite : IN STD_LOGIC;
			Clock, Reset : IN STD_LOGIC
		);
	END COMPONENT;
	--COMPONENT sevenseg_display IS
	-- PORT( Digit1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	-- Digit2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	-- D1seg_a : OUT STD_LOGIC;
	-- D1seg_b : OUT STD_LOGIC;
	-- D1seg_c : OUT STD_LOGIC;
	-- D1seg_d : OUT STD_LOGIC;
	-- D1seg_e : OUT STD_LOGIC;
	-- D1seg_f : OUT STD_LOGIC;
	-- D1seg_g : OUT STD_LOGIC;
	-- D1pb : OUT STD_LOGIC;
	-- D2seg_a : OUT STD_LOGIC;
	-- D2seg_b : OUT STD_LOGIC;
	-- D2seg_c : OUT STD_LOGIC;
	-- D2seg_d : OUT STD_LOGIC;
	-- D2seg_e : OUT STD_LOGIC;
	-- D2seg_f : OUT STD_LOGIC;
	-- D2seg_g : OUT STD_LOGIC;
	-- D2pb : OUT STD_LOGIC;
	-- Clock, Reset : IN STD_LOGIC);
	--END COMPONENT;
	--Signals used to connect VHDL Components
	SIGNAL Add_Result : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ALU_Result : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL ALU_Op : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL ALUSrc : STD_LOGIC;
	SIGNAL Branch : STD_LOGIC;
	SIGNAL Branch_NE : STD_LOGIC;
	SIGNAL Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Jump : STD_LOGIC;
	SIGNAL Jump_Address : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL Jump_Instr : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL MemRead : STD_LOGIC;
	SIGNAL MemtoReg : STD_LOGIC;
	SIGNAL MemWrite : STD_LOGIC;
	SIGNAL PC_Out : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL PC_plus_4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Read_data : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL Read_Data_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL Read_Data_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL RegDst : STD_LOGIC;
	SIGNAL RegWrite : STD_LOGIC;
	SIGNAL Sign_Extend : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL Write_Reg : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL Zero : STD_LOGIC;
	--New Clock Signal used when PushButton is used
	--to create a clock tick
	SIGNAL NClock : STD_LOGIC;
	SIGNAL clk1hz: std_logic;
BEGIN
	--Signals assigned to display output pins for simulator
	--These signals must be commented when implementing
	--the UP2 Development board.
	PC <= PC_Out;
	ALU_Result_out <= ALU_Result;
	Read_Data1_out <= Read_Data_1;
	Read_Data2_out <= Read_Data_2;
	Write_Data_out <= Read_data WHEN (MemtoReg = '1') ELSE ALU_Result;
	Write_Reg_out <= Write_Reg;
	Instruction_out<= Instruction;
	Branch_out <= Branch;
	Branch_NE_out <= Branch_NE;
	Zero_out <= Zero;
	Jump_out <= Jump;
	MemWrite_out <= MemWrite;
	RegWrite_out <= '0' WHEN Write_Reg = "00000" ELSE RegWrite;
	
	clk1: entity work.clk_1hz
		port map(
			clk => clock,
			reset => reset,
			clk1hz => clk1hz
		);
	
	--Connect each signal to respective line
	--NCLK: debounce PORT MAP(
	-- Clock => Clock,
	-- PButton => PB,
	-- Pulse => NClock);
	IFE : instrfetch PORT MAP (
		PC_Out => PC_Out,
		Instruction => Instruction,
		Add_Result => Add_Result,
		PC_plus_4_out => PC_plus_4,
		Branch => Branch,
		Branch_NE => Branch_NE,
		Zero => Zero,
		Jump => Jump,
		Jump_Address => Jump_Address,
		Clock => Clock,
		Reset => Reset,
		Enable => clk1hz
	);
	ID : operandfetch PORT MAP (
		Read_Data_1 => Read_Data_1,
		Read_Data_2 => Read_Data_2,
		Write_Reg => Write_Reg,
		RegWrite => RegWrite,
		RegDst => RegDst,
		ALU_Result => ALU_Result,
		MemtoReg => MemtoReg,
		Read_data => Read_data,
		Instruction => Instruction,
		Sign_Extend => Sign_Extend,
		Jump_Instr => Jump_Instr,
		Clock => clock,
		Reset => Reset 
	);
	CTRL : controlunit PORT MAP (
		Opcode => Instruction (31 DOWNTO 26),
		RegDst => RegDst,
		Jump => Jump,
		Branch => Branch,
		Branch_NE => Branch_NE,
		MemRead => MemRead,
		MemtoReg => MemtoReg,
		ALU_Op => ALU_Op,
		MemWrite => MemWrite,
		ALUSrc => ALUSrc,
		RegWrite => RegWrite,
		Clock => clock,
		Reset => Reset 
	);
	EX : execution PORT MAP (
		Read_Data_1 => Read_Data_1,
		Read_Data_2 => Read_Data_2,
		Sign_Extend => Sign_Extend,
		ALUSrc => ALUSrc,
		Zero => Zero,
		ALU_Result => ALU_Result,
		Funct_field => Instruction (5 DOWNTO 0),
		ALU_Op => ALU_Op,
		Add_Result => Add_Result,
		PC_plus_4 => PC_plus_4,
		Jump_Address => Jump_Address,
		Jump_Instr => Jump_Instr,
		Clock => clock,
		Reset => Reset 
	);
	MEM : datamemory PORT MAP (
		Read_Data => Read_Data,
		Address => ALU_Result,
		Write_Data => Read_Data_2,
		MemRead => MemRead,
		MemWrite => MemWrite,
		Clock => Clock,
		Reset => Reset 
	);
	
	led <= pc_out;
	
	-- SSD: sevenseg_display PORT MAP(
	-- Digit1 => PC_Out (7 DOWNTO 4),
	-- Digit2 => PC_Out (3 DOWNTO 0),
	-- D1seg_a => D1_a,
	-- D1seg_b => D1_b,
	-- D1seg_c => D1_c,
	-- D1seg_d => D1_d,
	-- D1seg_e => D1_e,
	-- D1seg_f => D1_f,
	-- D1seg_g => D1_g,
	-- D1pb => D1_pb,
	-- D2seg_a => D2_a,
	-- D2seg_b => D2_b,
	-- D2seg_c => D2_c,
	-- D2seg_d => D2_d,
	-- D2seg_e => D2_e,
	-- D2seg_f => D2_f,
	-- D2seg_g => D2_g,
	-- D2pb => D2_pb,
	-- Clock => NClock,
	-- Reset => Reset);
END structure;