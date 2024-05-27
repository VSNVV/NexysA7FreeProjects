library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_counter_leds is
    port(RST        : in  std_logic;
         CLK        : in  std_logic; 
         ACTIVATE_LEDS : out std_logic_vector(15 downto 0));
end test_counter_leds;

architecture rtl of test_counter_leds is
begin
    U_COUNTER_LEDS: entity work.counter_leds
    port map(
        RST => RST,
        CLK => CLK,
        ACTIVATE_LEDS => ACTIVATE_LEDS);
end rtl;