----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2015 06:17:17 PM
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    port(
        clk: in std_logic;
        reset: in std_logic;
        uart_rx: in std_logic;
        uart_tx: out std_logic;
        sw: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        seg: out std_logic_vector(6 downto 0);
        btnu: in std_logic;
        btnd: in std_logic;
        btnl: in std_logic;
        btnr: in std_logic;
        btnc: in std_logic
    );
end main;

architecture Behavioral of main is

signal output: std_logic_vector(31 downto 0);
signal input: std_logic_vector(31 downto 0);
signal reset_inv: std_logic;
signal pc: std_logic_vector(7 downto 0);

COMPONENT controller
  PORT (
    Clk : IN STD_LOGIC;
    Reset : IN STD_LOGIC;
    UART_Rx : IN STD_LOGIC;
    UART_Tx : OUT STD_LOGIC;
    UART_Interrupt : OUT STD_LOGIC;
    GPO1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    GPI1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    GPI1_Interrupt : OUT STD_LOGIC;
    INTC_IRQ : OUT STD_LOGIC
  );
END COMPONENT;


begin
    controller_inst : controller
      PORT MAP (
        Clk => Clk,
        Reset => reset_inv,
        UART_Rx => UART_Rx,
        UART_Tx => UART_Tx,
        UART_Interrupt => open,
        GPO1 => output,
        GPI1 => input,
        GPI1_Interrupt => open,
        INTC_IRQ => open
      );
      
    mips_sc_inst: entity work.mips_sc(structure) port map(
        clock => clk,
        reset => reset_inv,
        pc => pc
    );
      
    led(7 downto 0) <= pc;
    led(15 downto 8) <= (others => '0');
    input(15 downto 0) <= sw;
    input(31 downto 16) <= (others => '0');
    reset_inv <= not reset;
end Behavioral;
