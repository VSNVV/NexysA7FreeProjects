library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity switches_leds is
    port(RST        : in  std_logic;
         CLK        : in  std_logic; 
         SWITCHES   : in  std_logic_vector(15 downto 0);
         ACTIVATE_LEDS : out std_logic_vector(15 downto 0));
end switches_leds;

architecture rtl of switches_leds is
-- Declaracion de Sennales
begin
    process(CLK, RST, SWITCHES) -- Registro que lee la entrada de los switches y la envía a los leds
    begin
        if RST = '1' then
            ACTIVATE_LEDS <= (others => '0');
        elsif CLK'event and CLK = '1' then
            ACTIVATE_LEDS <= SWITCHES;
        end if;
    end process;
end rtl;