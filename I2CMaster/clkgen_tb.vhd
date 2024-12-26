library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkgen_tb is
-- El testbench no tiene puertos
end clkgen_tb;

architecture sim of clkgen_tb is

    -- Component declaration for clkgen10kHz
    component clkgen10kHz is
        port(
            RST : in std_logic;
            CLK_IN : in std_logic;
            CLK_OUT : out std_logic
        );
    end component;

    -- Señales internas para conectar al DUT (Device Under Test)
    signal RST : std_logic := '0';
    signal CLK_IN : std_logic := '0';
    signal CLK_OUT : std_logic;

    -- Parámetros para la generación del reloj
    constant CLK_PERIOD : time := 10 ns; -- Periodo del reloj de entrada (100 MHz)

begin
    -- Instancia del DUT
    DUT: clkgen10kHz
        port map(
            RST => RST,
            CLK_IN => CLK_IN,
            CLK_OUT => CLK_OUT
        );

    -- Generación de la señal de reloj de entrada (100 MHz)
    CLK_GEN: process
    begin
        while true loop
            CLK_IN <= '0';
            wait for CLK_PERIOD / 2;
            CLK_IN <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process CLK_GEN;

    -- Proceso de estimulación
    STIMULUS: process
    begin
        -- Inicialización
        RST <= '1'; -- Reset activo
        wait for 50 ns;
        RST <= '0'; -- Desactivamos el reset
        wait for 1 us; -- Esperamos para observar el comportamiento del divisor

        -- Prueba extendida
        wait for 10 ms; -- Simulación de 10 ms para verificar múltiples ciclos

        -- Finalización de la simulación
        report "FIN CONTROLADO DE LA SIMULACION" severity failure;
    end process STIMULUS;

end sim;
