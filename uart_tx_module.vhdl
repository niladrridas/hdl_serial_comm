library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UART_TX is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(7 downto 0);
           tx : out STD_LOGIC;
           tx_busy : out STD_LOGIC);
end UART_TX;

architecture Behavioral of UART_TX is
    signal bit_count : integer := 0;
    signal shift_reg : STD_LOGIC_VECTOR(10 downto 0) := (others => '1');
    signal start_tx : boolean := false;
    signal stop_tx : boolean := false;
    signal tx_reg : STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
    signal tx_busy_internal : STD_LOGIC := '0';

begin
    process(clk, reset)
    begin
        if reset = '1' then
            bit_count <= 0;
            shift_reg <= (others => '1');
            start_tx <= false;
            stop_tx <= false;
            tx_reg <= (others => '1');
            tx_busy_internal <= '0';
        elsif rising_edge(clk) then
            if start_tx = true then
                if bit_count < 10 then
                    shift_reg <= '0' & data_in(7) & shift_reg(10 downto 1);
                    bit_count <= bit_count + 1;
                else
                    stop_tx <= true;
                end if;
            elsif stop_tx = true then
                tx_reg <= '1' & shift_reg(9 downto 1);
                tx_busy_internal <= '0';
                stop_tx <= false;
            elsif tx_busy_internal = '0' then
                tx_reg <= (others => '1');
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_tx = false and tx_busy_internal = '1' then
                tx_busy_internal <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_tx = true and tx_busy_internal = '0' then
                tx_busy_internal <= '1';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_tx = false and tx_busy_internal = '0' then
                tx <= '1';
            elsif tx_reg(0) = '1' then
                tx <= '1';
            else
                tx <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_tx = true then
                tx_busy <= '1';
            else
                tx_busy <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if start_tx = false and tx_busy_internal = '1' then
                bit_count <= 0;
                start_tx <= false;
            elsif start_tx = false and tx_busy_internal = '0' then
                if tx_reg = (others => '1') then
                    start_tx <= false;
                else
                    start_tx <= true;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
