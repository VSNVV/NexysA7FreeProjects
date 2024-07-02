library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity c2_decoder is
    port(
        CLK : in std_logic;
        NUMBER_BIN : in std_logic_vector(1 downto 0);
        NUMBER_C2  : out std_logic_vector(1 downto 0)
    );
end c2_decoder;

architecture rtl of c2_decoder is
-- Declaracion de Sennales y/o Constantes
signal RegisterOut : std_logic_vector(1 downto 0);

begin
    RegisterNumberBin: process(CLK, NUMBER_BIN)
    begin
        if rising_edge(CLK) then
            RegisterOut <= NUMBER_BIN;
        end if;
    end process RegisterNumberBin;

    DecoderBinToC2: process(RegisterOut)
    variable temp : unsigned((RegisterOut'length - 1) downto 0);
    begin
        temp := unsigned(RegisterOut);
        temp := (not temp) + 1;
        NUMBER_C2 <= std_logic_vector(temp);
    end process DecoderBinToC2;
end rtl;