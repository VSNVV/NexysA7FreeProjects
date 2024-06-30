library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_booth_algorithm is
    port(
        CLK : in std_logic;
        NUMBER_A : in std_logic_vector(1 downto 0);
        NUMBER_B : in std_logic_vector(1 downto 0);
        NUMBER_OUT : out std_logic_vector(3 downto 0)
    );
end test_booth_algorithm;

architecture Behavorial of test_booth_algorithm is
-- Declaracion de Sennales y/o Constantes

begin
    U_BOOTH_MULTIPLIER: entity work.booth_algorithm
    port map(
        CLK => CLK,
        NUMBER_A => NUMBER_A,
        NUMBER_B => NUMBER_B,
        NUMBER_OUT => NUMBER_OUT
    );
end Behavorial;