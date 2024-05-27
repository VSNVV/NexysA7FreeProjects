library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_johnson_counter is
    port(RST        : in  std_logic;
         CLK        : in  std_logic;
         DIRECTION  : in  std_logic; -- 1 --> Ascendente | 0 --> Descendente
         POL        : in  std_logic;
         COUNTER_OUT : out std_logic_vector(15 downto 0));
end test_johnson_counter;

architecture rtl of test_johnson_counter is
begin
    U_JOHNSON_COUNTER: entity work.johnson_counter
    port map(
        RST => RST,
        CLK => CLK,
        DIRECTION => DIRECTION,
        POL => POL,
        COUNTER_OUT => COUNTER_OUT);
end rtl;