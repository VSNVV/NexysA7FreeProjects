library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_switches_leds is
    port(RST        : in  std_logic;
         CLK        : in  std_logic; 
         SWITCHES   : in  std_logic_vector(15 downto 0);
         ACTIVATE_LEDS : out std_logic_vector(15 downto 0));
end test_switches_leds;

architecture rtl of test_switches_leds is

begin
    U_SWITCHES_LEDS: entity work.switches_leds
    port map(
        RST => RST,
        CLK => CLK,
        SWITCHES => SWITCHES,
        ACTIVATE_LEDS => ACTIVATE_LEDS);
end rtl;