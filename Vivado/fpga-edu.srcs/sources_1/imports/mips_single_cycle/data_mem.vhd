------------------------------------------------------------------
-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: data_memory.vhd
-- Description: VHDL code to implment the Instruction Fetch unit
-- of the MIPS single-cycle processor as seen in Chapter #5 of
-- Patterson and Hennessy book. This file involves the use of the
-- LPM Components (LPM_RAM) to declare the Instruction Memory
-- as a random access memory (RAM). See MAX+PLUS II Help on
-- "Implementing RAM & ROM (VHDL)" for details.
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
--LIBRARY LPM;
--USE LPM.LPM_COMPONENTS.ALL;
ENTITY datamemory IS
	PORT (
		Read_Data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Write_Data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		MemRead : IN STD_LOGIC;
		MemWrite : IN STD_LOGIC;
		Clock, Reset : IN STD_LOGIC
	);
END datamemory;
ARCHITECTURE behavior OF datamemory IS
	SIGNAL LPM_WRITE : STD_LOGIC;
	COMPONENT data_mem
	  PORT (
 		  clka : IN STD_LOGIC;
		  wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
 		  addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
BEGIN
	datamemory : data_mem
   PORT MAP (
      clka => clock,
      wea(0) => lpm_write,
      addra => address,
      dina => write_data,
      douta => read_data
   );
--	datamemory : LPM_RAM_DQ
--	GENERIC MAP(
--		LPM_WIDTH => 8, 
--		LPM_WIDTHAD => 8, 
--		LPM_FILE => "data_memory.mif", 
--		LPM_INDATA => "REGISTERED", 
--		LPM_ADDRESS_CONTROL => "UNREGISTERED", 
--	LPM_OUTDATA => "UNREGISTERED")
--	PORT MAP(
--		inclock => Clock, 
--		data => Write_Data, 
--		address => Address, 
--		we => LPM_WRITE, 
--		q => Read_Data
--	);
	--Write Data Memory
	LPM_WRITE <= MemWrite AND (NOT Clock);
END behavior;