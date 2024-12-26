library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_variable_blink is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        LED : out std_logic
    );
end test_variable_blink;

architecture Behavorial of test_variable_blink is
-- Declaracion de Sennales y/o Constantes

begin
    U_VARIABLE_BLINK: entity work.variable_blink
    port map(
        CLK => CLK,
        RST => RST,
        LED => LED
    );
end Behavorial;