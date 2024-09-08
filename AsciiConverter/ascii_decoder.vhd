library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_decoder is
    port(
        CLK : in std_logic;
        DATA_RX : in std_logic_vector(7 downto 0);
        DATA_RX_OK : in std_logic;
        RESULT : out std_logic_vector(7 downto 0)
    );
end ascii_decoder;

architecture rtl of ascii_decoder is
-- Declaracion de Sennales y/o Constantes
signal register_in : std_logic_vector(23 downto 0); -- Sennal de salida del Registro de Entrada
signal ascii_decoder : std_logic_vector(7 downto 0); -- Sennal de salida del Decodificador ASCII

begin
    RegisterIn: process(CLK, DATA_RX_OK, DATA_RX)
    begin
        if rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                if (DATA_RX >= x"30") and (DATA_RX <= x"39") then
                    register_in <= register_in(15 downto 0) & DATA_RX;
                end if;
            end if;
        end if;
    end process RegisterIn;

    AsciiDecoder: process(register_in)
    variable digit1, digit2, digit3 : integer := 0;
    variable result : integer := 0;
    begin
        if (register_in(23 downto 16) >= x"30") and (register_in(23 downto 16) <= x"39") then
            digit1 := to_integer(unsigned(register_in(23 downto 16))) - 48;
        else
            digit1 := 0;
        end if;
    
        if (register_in(15 downto 8) >= x"30") and (register_in(15 downto 8) <= x"39") then
            digit2 := to_integer(unsigned(register_in(15 downto 8))) - 48;
        else
            digit2 := 0;
        end if;
    
        if (register_in(7 downto 0) >= x"30") and (register_in(7 downto 0) <= x"39") then
            digit3 := to_integer(unsigned(register_in(7 downto 0))) - 48;
        else
            digit3 := 0;
        end if;
    
        result := (digit1 * 100) + (digit2 * 10) + (digit3);
    
        -- Asegura que 'result' sea un número válido entre 0 y 255
        ascii_decoder <= std_logic_vector(to_unsigned(result, 8));
    end process AsciiDecoder;

    
    RegisterOut: process(CLK, ascii_decoder)
    begin
        if rising_edge(CLK) then
            RESULT <= ascii_decoder;
        end if;
    end process RegisterOut;

end rtl;