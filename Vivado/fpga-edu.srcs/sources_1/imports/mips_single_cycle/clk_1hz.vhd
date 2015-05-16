----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:11:15 04/21/2015 
-- Design Name: 
-- Module Name:    clk_1hz - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_1hz is
	port( 
		clk, reset: in std_logic;
		clk1hz: out std_logic
	);
end clk_1hz;

architecture arch of clk_1hz is
   signal r_reg: integer;
   signal r_next: integer;
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= 0;
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   r_next <= 0 when r_reg=(12500000) else
             r_reg + 1;
   -- output logic
   clk1hz <= '1' when r_reg=(12500000) else '0';
end arch;

