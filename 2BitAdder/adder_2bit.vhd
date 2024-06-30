library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_2bit is
    port(CLK         : in std_logic;
        NUMBER1      : in std_logic_vector(1 downto 0);
        NUMBER2      : in std_logic_vector(1 downto 0);
        NUMBER_OUT   : out std_logic_vector(2 downto 0));
end adder_2bit;

architecture rtl of adder_2bit is
-- Declaracion de Sennales
signal RegNumber1Out, RegNumber2Out : std_logic_vector(1 downto 0);

begin
    RegisterNumber1: process(CLK, NUMBER1)
    begin
        if rising_edge(CLK) then
            RegNumber1Out <= NUMBER1;
        end if;
    end process RegisterNumber1;

    RegisterNumber2: process(CLK, NUMBER1)
    begin
        if rising_edge(CLK) then
            RegNumber2Out <= NUMBER2;
        end if;
    end process RegisterNumber2;

    Adder: process(RegNumber1Out, RegNumber2Out)
    variable num1, num2 : unsigned(1 downto 0);
    begin
        num1 := unsigned(RegNumber1Out);
        num2 := unsigned(RegNumber2Out);
        NUMBER_OUT <= std_logic_vector(('0' & num1) + ('0' & num2));
    end process Adder;

end rtl;