library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth_algorithm is
    port(
        CLK : in std_logic;
        NUMBER_A : in std_logic_vector(1 downto 0);
        NUMBER_B : in std_logic_vector(1 downto 0);
        NUMBER_OUT : out std_logic_vector(3 downto 0)
    );
end booth_algorithm;

architecture rtl of booth_algorithm is
-- Declaracion de Sennales y/o Constantes
signal RegNumberA, RegNumberB : std_logic_vector(1 downto 0); -- Sennales de salida de los registros
signal DecoderC2Out : std_logic_vector(1 downto 0); -- Sennal de salida del conversor a complemento a 2

begin
    RegisterNumberA: process(CLK, NUMBER_A)
    variable aux : unsigned(1 downto 0);
    begin
        -- Para el algoritmo de booth, ambos numeros tienen que estar en C2
        if rising_edge(CLK) then
            aux := unsigned(NUMBER_A);
            aux := (not aux) + 1;
            RegNumberA <= std_logic_vector(aux);
        end if;
    end process RegisterNumberA;

    RegisterNumberB: process(CLK, NUMBER_B)
    variable aux : unsigned(1 downto 0);
    begin
        if rising_edge(CLK) then
            aux := unsigned(NUMBER_B);
            aux := (not aux) + 1;
            RegNumberB <= std_logic_vector(aux);
        end if;
    end process RegisterNumberB;

    DecoderBinToC2: process(RegNumberA)
    variable aux : unsigned(1 downto 0);
    begin
        aux := unsigned(RegNumberA);
        aux := (not aux) + 1;
        DecoderC2Out <= std_logic_vector(aux); 
    end process DecoderBinToC2;

    BoothMultiplier: process(RegNumberA, RegNumberB, DecoderC2Out)
    -- A es el numero A
    -- S es el C2 de A
    -- P inicialmente es el numero B (a la derecha)
    variable a, s, p : unsigned(3 downto 0);
    variable q : std_logic;
    variable operand : std_logic_vector(1 downto 0);
    variable step : integer;
    begin
        step := 0;
        while(step < RegNumberA'length) loop
            if step = 0 then
                -- Es el paso inicial, incializaremos todos los registros
                a := unsigned(RegNumberA & "00");
                s := unsigned(DecoderC2Out & "00");
                p := unsigned("00" & RegNumberB);
                q := '0';
            else
                -- Tenemos que revisar la operacion que tenemos que usar mediante el LSB de P y el bit Q
                operand := p(0) & q;
                case(operand) is
                    when "10" =>
                        -- P = P + S
                        p := p + s;
                    when "01" =>
                        --P = P + A
                        p := p + a;
                    when others =>
                        -- Simplemente desplazamos
                        p := p;
                end case;
                -- Una vez que hemos hecho el operando correspondiente, desplazamos P un bit a la derecha
                q := p(0);
                p := p(3) & p(3 downto 1);
            end if;
            step := step + 1;
        end loop;
        NUMBER_OUT <= std_logic_vector(p);
    end process BoothMultiplier;
end rtl;