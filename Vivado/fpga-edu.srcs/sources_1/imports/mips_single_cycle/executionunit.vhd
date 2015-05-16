------------------------------------------------------------------
-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: execution_unit.vhd
-- Description: VHDL code to implment the Execution Unit
-- of the MIPS single-cycle processor as seen in Chapter #5 of
-- Patterson and Hennessy book.
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
ENTITY execution IS
PORT( --ALU Signals
Read_Data_1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
Read_Data_2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
Sign_Extend : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
ALUSrc : IN STD_LOGIC;
Zero : OUT STD_LOGIC;
ALU_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
--ALU Control
Funct_field : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
ALU_Op : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--Branch Adder
Add_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
PC_plus_4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--Jump Adress
Jump_Instr : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
Jump_Address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
--Misc
Clock, Reset : IN STD_LOGIC);
END execution;
ARCHITECTURE behavior of execution IS
SIGNAL A_input, B_input : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL ALU_output : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL Branch_Add : STD_LOGIC_VECTOR (8 DOWNTO 0);
SIGNAL Jump_Add : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL ALU_Control : STD_LOGIC_VECTOR (2 DOWNTO 0);
BEGIN
--ALU Input
A_input <= Read_Data_1;
--MUX to select second ALU Input
B_input <= Read_Data_2
WHEN (ALUSrc = '0')
ELSE (Sign_Extend (7 DOWNTO 0));
--Set ALU Control Bits
ALU_Control(2) <= ( Funct_field(1) AND ALU_Op(1) ) OR ALU_Op(0);
ALU_Control(1) <= ( NOT Funct_field(2) ) OR ( NOT ALU_Op(1) );
ALU_Control(0) <= ( Funct_field(1) AND Funct_field(3) AND ALU_Op(1) ) OR
( Funct_field(0) AND Funct_field(2) AND ALU_Op(1) );
--Set ALU_Zero
Zero <= '1' WHEN ( ALU_output (7 DOWNTO 0) = "00000000") ELSE '0';
--ALU Output: Must check for SLT instruction and set correct ALU_output
ALU_Result <= ("0000000" & ALU_output (7)) WHEN ALU_Control = "111"
ELSE ALU_output (7 DOWNTO 0);
--Branch Adder
Branch_Add <= (others => '0');--PC_plus_4 (7 DOWNTO 2) + Sign_Extend (7 DOWNTO 0);
Add_Result <= Branch_Add (7 DOWNTO 0);
--Jump Address
Jump_Add <= Jump_Instr (7 DOWNTO 0);
Jump_Address <= Jump_Add;
--Compute the ALU_output use the ALU_Control signals
PROCESS (ALU_Control, A_input, B_input)
BEGIN --ALU Operation
CASE ALU_Control IS
--Function: A_input AND B_input
WHEN "000" => ALU_output <= A_input AND B_input;
--Function: A_input OR B_input
WHEN "001" => ALU_output <= A_input OR B_input;
--Function: A_input ADD B_input
WHEN "010" => ALU_output <= A_input + B_input;
--Function: A_input ? B_input
WHEN "011" => ALU_output <= "00000000";
--Function: A_input ? B_input
WHEN "100" => ALU_output <= "00000000";
--Function: A_input ? B_input
WHEN "101" => ALU_output <= "00000000";
--Function: A_input SUB B_input
WHEN "110" => ALU_output <= A_input - B_input;
--Function: SLT (set less than)
WHEN "111" => ALU_output <= A_input - B_input;
WHEN OTHERS => ALU_output <= "00000000";
END CASE;
END PROCESS;
END behavior;