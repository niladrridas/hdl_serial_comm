library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UART_RX is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           rx : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(7 downto 0);
           rx_data_valid : out STD_LOGIC);
end UART_RX;

architecture Behavioral of UART_RX is
    signal bit_count : integer := 0;
    signal shift_reg : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal start_rx : boolean := false;
    signal stop_rx : boolean := false;
    signal rx_data_valid_internal : STD_LOGIC := '0';

begin
    process(clk, reset)
    begin
        if reset = '1' then
            bit_count <= 0;
            shift_reg <= (others => '0');
            start_rx <= false;
            stop_rx <= false;
            rx_data_valid_internal <= '0';
        elsif rising_edge(clk) then
            if start_rx = true then
                if bit_count < 10 then
                    shift_reg <= rx & shift_reg(9 downto 1);
                    bit_count <= bit_count + 1;
                else
                    stop_rx <= true;
                end if;
            elsif stop_rx = true then
                data_out <= shift_reg(8 downto 1);
                rx_data_valid_internal <= '1';
                stop_rx <= false;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_rx = false and rx_data_valid_internal = '1' then
                rx_data_valid_internal <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rx = '0' then
                start_rx <= true;
            else
                start_rx <= false;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_rx = false and rx_data_valid_internal = '1' then
                bit_count <= 0;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_rx = true then
                rx_data_valid <= '1';
            else
                rx_data_valid <= '0';
            end if;
        end if;
    end process;

end Behavioral;
