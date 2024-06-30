library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_multiplier_2bit is
    port(CLK    : in  std_logic;
    A           : in  std_logic_vector(1 downto 0);
    B           : in  std_logic_vector(1 downto 0);
    Q           : out std_logic_vector(3 downto 0)
    );
end test_multiplier_2bit;

architecture Behavorial of test_multiplier_2bit is
-- Declaracion de Sennales y/o Constantes

begin
    U_MULTIPLIER: entity work.multiplier_2bit
    port map(
        CLK => CLK,
        A => A,
        B => B,
        Q => Q
    );
end Behavorial;