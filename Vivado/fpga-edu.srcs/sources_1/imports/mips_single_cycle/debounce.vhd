------------------------------------------------------------------
-- Victor Rubio
-- Graduate Student
-- Klipsch School of Electrical and Computer Engineering
-- New Mexico State University
-- Las Cruces, NM
--
--
-- Filename: debounce.vhd
-- Description: VHDL code to debounce the UP2 Board push buttons.
-- without this code pushing the button could actually result
-- in multiple contacts due to the spring found in the push button.
-- ONLY USED in HARDWARE IMPLEMENTATION
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY debounce IS
PORT ( Clock : IN STD_LOGIC;
PButton : IN STD_LOGIC;
Pulse : OUT STD_LOGIC);
END debounce;
ARCHITECTURE behavior OF debounce IS
SIGNAL count : STD_LOGIC_VECTOR (17 DOWNTO 0);
BEGIN
PROCESS (Clock)
BEGIN
IF PButton = '1' THEN
count <= "000000000000000000";
ELSIF (Clock'EVENT AND Clock = '1') THEN
IF (count /= "111111111111111111") THEN
count <= count + 1;
END IF;
END IF;
IF (count = "111111111111111110") AND (PButton = '0') THEN
Pulse <= '1';
ELSE
Pulse <= '0';
END IF;
END PROCESS;
END behavior;