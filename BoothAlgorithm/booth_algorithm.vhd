library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth_algorithm is
    port(
        CLK : in std_logic;
        NUMBER_A : in std_logic_vector(1 downto 0);
        NUMBER_B : in std_logic_vector(1 downto 0);
        NUMBER_OUT : out std_logic_vector(7 downto 0)
    );
end booth_algorithm;

architecture rtl of booth_algorithm is
-- Declaracion de Sennales y/o Constantes
signal RegNumberA, RegNumberB : std_logic_vector(3 downto 0); -- Sennales de salida de los registros

begin
    RegisterNumberA: process(CLK, NUMBER_A)
    begin
        if rising_edge(CLK) then
            RegNumberA <= "00" & NUMBER_A;
        end if;
    end process RegisterNumberA;

    RegisterNumberB: process(CLK, NUMBER_B)
    begin
        if rising_edge(CLK) then
            RegNumberB <= "00" & NUMBER_B;
        end if;
    end process RegisterNumberB;

    BoothMultiplier: process(RegNumberA, RegNumberB)
    -- A es el numero A
    -- S es el C2 de A
    -- P inicialmente es el numero B (a la derecha)
    variable a, s, p : unsigned(7 downto 0);
    variable c2_number_a : unsigned(3 downto 0);
    variable q : std_logic;
    variable operand : std_logic_vector(1 downto 0);
    variable step : integer;
    begin
        step := 0;
        while(step < RegNumberA'length + 1) loop
            if step = 0 then
                -- Es el paso inicial, incializaremos todos los registros
                a := unsigned(RegNumberA & "0000");
                c2_number_a := unsigned(RegNumberA);
                c2_number_a := (not c2_number_a) + 1;
                s := c2_number_a & "0000";
                p := unsigned("0000" & RegNumberB);
                q := '0';
            else
                -- Tenemos que revisar la operacion que tenemos que usar mediante el LSB de P y el bit Q
                operand := p(0) & q;
                case(operand) is
                    when "10" =>
                        -- P = P + S
                        p := p + s;
                    when "01" =>
                        -- P = P + A
                        p := p + a;
                    when others =>
                        -- No se realiza ninguna operacion
                        p := p;
                end case;
                -- Una vez que hemos hecho el operando correspondiente, desplazamos P un bit a la derecha teniendo en cuenta Q
                q := p(0);
                p := p(7) & p(7 downto 1);
            end if;
            step := step + 1;
        end loop;
        NUMBER_OUT <= std_logic_vector(p);
    end process BoothMultiplier;
end rtl;