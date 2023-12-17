library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX_tb is
end UART_RX_tb;

architecture SIM of UART_RX_tb is
    signal clk, reset, rx, rx_data_valid: std_logic := '0';
    signal data_out: std_logic_vector(7 downto 0);
begin
    uut: entity work.UART_RX
        port map (
            clk => clk,
            reset => reset,
            rx => rx,
            data_out => data_out,
            rx_data_valid => rx_data_valid
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
