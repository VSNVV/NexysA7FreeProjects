library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_adder_2bit is
    port(
        CLK         : in std_logic;
        NUMBER1     : in std_logic_vector(1 downto 0);
        NUMBER2     : in std_logic_vector(1 downto 0);
        RESULT      : out std_logic_vector(2 downto 0));
        
end test_adder_2bit;

architecture Behavorial of test_adder_2bit is
-- Declaracion de Sennales

begin
    U_ADDER: entity work.adder_2bit
    port map(
        CLK => CLK,
        NUMBER1 => NUMBER1,
        NUMBER2 => NUMBER2,
        NUMBER_OUT => RESULT
    );

end Behavorial;