library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_c2_decoder is
    port(
        CLK : in std_logic;
        NUMBER_BIN : in std_logic_vector(1 downto 0);
        NUMBER_C2 : out std_logic_vector(1 downto 0)
    );
end test_c2_decoder;

architecture Behavorial of test_c2_decoder is
-- Declaracion de Sennales y/o Constantes

begin
    U_C2_DECODER: entity work.c2_decoder
    port map(
        CLK => CLK,
        NUMBER_BIN => NUMBER_BIN,
        NUMBER_C2 => NUMBER_C2
    );
end Behavorial;