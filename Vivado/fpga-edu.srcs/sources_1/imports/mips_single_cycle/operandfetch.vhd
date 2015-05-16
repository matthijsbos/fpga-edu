------------------------------------------------------------------
-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: operandfetch.vhd
-- Description: VHDL code to implment the Operand Fetch unit
-- of the MIPS single-cycle processor as seen in Chapter #5 of
-- Patterson and Hennessy book.
--
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY operandfetch IS
	PORT (--Registers & MUX
		Read_Data_1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Read_Data_2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Write_Reg : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		RegWrite : IN STD_LOGIC;
		RegDst : IN STD_LOGIC;
		--Data Memory & MUX
		ALU_Result : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		MemtoReg : IN STD_LOGIC;
		Read_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		--Misc
		Instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		Sign_Extend : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Jump_Instr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Clock, Reset : IN STD_LOGIC
	);
END operandfetch;

ARCHITECTURE behavior OF operandfetch IS
	--Declare Register File as a one-dimensional array
	--Thirty-two Registers each 8-bits wide
	TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL register_array : register_file;
	SIGNAL read_register_address1 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL read_register_address2 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL write_register_address : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL write_register_address0 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL write_register_address1 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL write_data : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL instruction_15_0 : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL instruction_25_0 : STD_LOGIC_VECTOR (25 DOWNTO 0);
BEGIN
	--Copy Instruction bits to signals
	read_register_address1 <= Instruction (25 DOWNTO 21);
	read_register_address2 <= Instruction (20 DOWNTO 16);
	write_register_address0 <= Instruction (20 DOWNTO 16);
	write_register_address1 <= Instruction (15 DOWNTO 11);
	instruction_15_0 <= Instruction (15 DOWNTO 0);
	instruction_25_0 <= Instruction (25 DOWNTO 0);
	--Register File: Read_Data_1 Output
	Read_Data_1 <= register_array(CONV_INTEGER(read_register_address1 (4 DOWNTO 0)));
	--Register File: Read_Data_2 Output
	Read_Data_2 <= register_array(CONV_INTEGER(read_register_address2 (4 DOWNTO 0)));
	--Register File: MUX to select Write Register Address
	write_register_address <= write_register_address1 WHEN (RegDst = '1')
	                          ELSE write_register_address0;
	--Register File: MUX to select Write Register Data
	write_data <= ALU_result (7 DOWNTO 0) WHEN (MemtoReg = '0')
	              ELSE Read_data;
	--Sign Extend
	--NOTE: Due to 8-bit data width design
	--No sign extension is NEEDED
	Sign_Extend <= instruction_15_0 (7 DOWNTO 0);
	--Jump Instruction
	Jump_Instr <= instruction_25_0 (7 DOWNTO 0);
	--WB - Write Register
	Write_Reg <= write_register_address;
	PROCESS
	BEGIN
		WAIT UNTIL (Clock'EVENT ) AND (Clock = '1' );
		IF (Reset = '1') THEN
			--Reset Registers to own Register Number
			--Used for testing ease.
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR(i, 8);
			END LOOP;
			--Write Register File if RegWrite signal asserted
		ELSIF (RegWrite = '1') AND (write_register_address /= 0) THEN
			register_array(CONV_INTEGER(write_register_address (4 DOWNTO 0))) <= write_data;
		END IF;
	END PROCESS;
END behavior;
------------------------------------------------------------------

