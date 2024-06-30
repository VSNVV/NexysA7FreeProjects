library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_2bit is
    port(CLK : in std_logic;
    A : in std_logic_vector(1 downto 0); -- Numero de 2 bits
    B : in std_logic_vector(1 downto 0); -- Numero de 2 bits
    Q : out std_logic_vector(3 downto 0) -- Resultado de la operacion, que como maximo puede ser de 4 bits (3 x 3 = 9 = 1001)
    );
end multiplier_2bit;

architecture rtl of multiplier_2bit is
-- Declaracion de Sennales y/o constantes
signal RegisterA, RegisterB : std_logic_vector(1 downto 0); -- Sennales de salida de los Registros (o biestables D) de los numeros A y B

begin
    RegisterNumberA: process(CLK, A)
    begin
        if rising_edge(CLK) then
            RegisterA <= A;
        end if;
    end process RegisterNumberA;

    RegisterNumberB: process(CLK, B)
    begin
        if rising_edge(CLK) then
            RegisterB <= B;
        end if;
    end process RegisterNumberB;

    MultiplierAddAndShift: process(RegisterA, RegisterB)
    variable count, aux2 : unsigned(3 downto 0);
    variable aux1 : unsigned(1 downto 0);
    begin
        count := (others => '0'); -- Reiniciamos la cuenta inicial cada vez que iniciemos el algoritmo de suma y desplazamiento
        for index in B'reverse_range loop
            aux2 := (others => '0'); -- Limpiamos la variable que va desplazando A segun los 1 que tenga B
            if B(index) = '1' then
                aux2(1 + index downto index) := unsigned(A); -- Desplazamos el numero de veces necesarias en las que nos encontremos un 1
            else
                aux2(1 + index downto index) := (others => '0'); -- Ponemos todo ceros, porque el bit de B es 0
            end if;
            count := count + aux2; -- Sumamos lo obtenido en funcion del bit del numero B
        end loop;
        Q <= std_logic_vector(count);
    end process MultiplierAddAndShift;
end rtl;