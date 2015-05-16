-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: control_unit.vhd
-- Description: VHDL code to implement the Control Unit
-- of the MIPS single-cycle processor as seen in Chapter #5 of
-- Patterson and Hennessy book.
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
ENTITY controlunit IS
PORT( SIGNAL Opcode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
SIGNAL RegDst : OUT STD_LOGIC;
SIGNAL Branch : OUT STD_LOGIC;
SIGNAL Branch_NE : OUT STD_LOGIC;
SIGNAL MemRead : OUT STD_LOGIC;
SIGNAL MemtoReg : OUT STD_LOGIC;
SIGNAL ALU_Op : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
SIGNAL MemWrite : OUT STD_LOGIC;
SIGNAL ALUSrc : OUT STD_LOGIC;
SIGNAL RegWrite : OUT STD_LOGIC;
SIGNAL Jump : OUT STD_LOGIC;
SIGNAL Clock, Reset : IN STD_LOGIC);
END controlunit;
ARCHITECTURE behavior OF controlunit IS
SIGNAL R_format, LW, SW, BEQ, BNE, JMP, ADDI : STD_LOGIC;
SIGNAL Opcode_Out : STD_LOGIC_VECTOR (5 DOWNTO 0);
BEGIN
--Decode the Instruction OPCode to determine type
--and set all corresponding control signals &
--ALUOP function signals.
R_format <= '1' WHEN Opcode = "000000" ELSE '0';
LW <= '1' WHEN Opcode = "100011" ELSE '0';
SW <= '1' WHEN Opcode = "101011" ELSE '0';
BEQ <= '1' WHEN Opcode = "000100" ELSE '0';
BNE <= '1' WHEN Opcode = "000101" ELSE '0';
JMP <= '1' WHEN Opcode = "000010" ELSE '0';
ADDI <= '1' WHEN Opcode = "001000" ELSE '0';
RegDst <= R_format;
Branch <= BEQ;
Branch_NE <= BNE;
Jump <= JMP;
MemRead <= LW;
MemtoReg <= LW;
ALU_Op(1) <= R_format;
ALU_Op(0) <= BEQ OR BNE;
MemWrite <= SW;
ALUSrc <= LW OR SW OR ADDI;
RegWrite <= R_format OR LW OR ADDI;
END behavior;