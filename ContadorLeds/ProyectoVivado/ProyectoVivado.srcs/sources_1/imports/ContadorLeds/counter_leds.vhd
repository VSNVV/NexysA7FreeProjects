library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_leds is
    port(RST        : in  std_logic;
         CLK        : in  std_logic; 
         ACTIVATE_LEDS : out std_logic_vector(15 downto 0));
end counter_leds;

architecture rtl of counter_leds is
-- Declaracion de Sennales y/o constantes
constant CLKDIV : integer := 100000000;
signal PROut : std_logic; -- Sennal de salida del Prescaler

begin
    Prescaler: process(CLK, RST)
    variable count : integer := 0;
    begin
        if RST = '1' then
            count := 0;
            PROut <= '0';
        elsif CLK'event and CLK = '1' then
            if count = CLKDIV then
                count := 0;
                PROut <= '1';
            else
                count := count + 1;
                PROut <= '0';
            end if;
        end if;
    end process Prescaler;

    Counter: process(CLK, RST, PROut) -- Proceso que modela el contador de leds activos
    variable auxLeds : std_logic_vector(15 downto 0);
    begin
        if RST = '1' then
            auxLeds := (others => '0');
        elsif CLK'event and CLK = '1' then
            if auxLeds = "1111111111111111" then
                auxLeds := (others => '0');
            else
                auxLeds := auxLeds(14 downto 0) & '1';
            end if;
        end if;
        ACTIVATE_LEDS <= auxLeds;
    end process Counter;
    
end rtl;
