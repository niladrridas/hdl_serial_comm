library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX_tb is
end UART_TX_tb;

architecture SIM of UART_TX_tb is
    signal clk, reset, tx, tx_busy: std_logic := '0';
    signal data_in: std_logic_vector(7 downto 0) := "01011010";
begin
    uut: entity work.UART_TX
        port map (
            clk => clk,
            reset => reset,
            data_in => data_in,
            tx => tx,
            tx_busy => tx_busy
        );

    clock_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_process: process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Add your test scenarios here

        wait;
    end process;
end SIM;
