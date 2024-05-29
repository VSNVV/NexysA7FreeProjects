library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity johnson_counter is
    port(RST        : in  std_logic;
         CLK        : in  std_logic;
         DIRECTION  : in  std_logic; -- 1 --> Ascendente | 0 --> Descendente
         POL        : in  std_logic;
         COUNTER_OUT : out std_logic_vector(15 downto 0));
end johnson_counter;

architecture rtl of johnson_counter is
-- Declaracion de Sennales y/o constantes
constant CLKDIV : integer := 50000000; -- Constante del prescaler para activar la salida cada medio segundo
signal PROut : std_logic; -- Sennal de salida del Prescaler
signal pol_reg : std_logic; -- Sennal auxiliar para detctar cambios en POL

begin
    Prescaler: process(CLK, RST)
    variable count_reg : integer := 0;
    begin
        if RST = '1' then
            count_reg := 0;
            PROut <= '0';
        elsif CLK'event and CLK = '1' then
            if count_reg = CLKDIV then
                count_reg := 0;
                PROut <= '1';
            else
                count_reg := count_reg + 1;
                PROut <= '0';
            end if;
        end if;
    end process Prescaler;

    JohnsonCounter: process(CLK, RST, PROut, DIRECTION, POL)
    -- Declaracion de variables
    variable result : std_logic_vector(15 downto 0) := "0000000000000001";
    begin
        if RST = '1' then
            result := (others => not POL);
            if DIRECTION = '1' then
                result := result(15 downto 1) & POL;
            else
                result := POL & result(14 downto 0);
            end if;
        elsif CLK'event and CLK = '1' then
            if PROut = '1' then
                pol_reg <= POL;
                if DIRECTION = '1' then
                    result := result(14 downto 0) & result(15);
                else
                    result := result(0) & result(15 downto 1);
                end if;
                if POL = not pol_reg then
                    result := not result;
                end if;
            end if;
        end if;
        COUNTER_OUT <= result;
    end process JohnsonCounter;
end rtl;
