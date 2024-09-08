library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_enter is
    port(
        CLK : in std_logic;
        DATA_RX : in std_logic_vector(7 downto 0);
        DATA_RX_OK : in std_logic;
        RESULT : out std_logic
    );
end comparator_enter;

architecture rtl of comparator_enter is
signal register_in : std_logic_vector(7 downto 0); -- Sennal de salida del Registro de Entrada

begin

    RegisterIn: process(CLK, DATA_RX, DATA_RX_OK)
    begin
        if rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                register_in <= DATA_RX;
            end if;
        end if;
    end process RegisterIn;

    Comparator: process(DATA_RX, DATA_RX_OK, register_in)
    begin
        if register_in = x"0D" then
            RESULT <= '1';
        else
            RESULT <= '0';
        end if;
    end process Comparator;
end rtl;