library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_master_tb is
end i2c_master_tb;

architecture sim of i2c_master_tb is
    -- Señales para conectar con el DUT
    signal RST : std_logic := '0';
    signal CLK : std_logic := '0';
    signal SDA : std_logic := 'Z';
    signal SCL : std_logic;
    signal DATA : std_logic_vector(7 downto 0);

    -- Señales internas para simular SDA
    signal sda_internal : std_logic := 'Z';

    -- Parámetros para la simulación
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instancia del módulo bajo prueba (DUT)
    uut: entity work.i2c_master
        port map (
            RST => RST,
            CLK => CLK,
            SDA => SDA,
            SCL => SCL,
            DATA => DATA
        );

    -- Generación del reloj
    clk_gen: process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_gen;

    -- Simulación de la señal SDA
    sda_driver: process
    begin
        wait for 50 ns; -- Espera a que el DUT tome control de SDA
        if sda_internal /= 'Z' then
            SDA <= sda_internal; -- Asigna el valor simulado a SDA
        else
            SDA <= 'Z'; -- Liberar SDA
        end if;
        wait for CLK_PERIOD; -- Sincronización
    end process sda_driver;

    -- Estímulos para la simulación
    stimulus: process
    begin
        -- Reset del sistema
        RST <= '1';
        wait for 100 ns;
        RST <= '0';

        -- Simular operación básica del I2C
        -- Espera el inicio de la comunicación
        wait for 500 ns;

        -- Simula el ACK del esclavo
        sda_internal <= '0';
        wait for 100 ns;
        sda_internal <= 'Z';

        -- Simula datos en el bus
        wait for 1 us;
        sda_internal <= '1'; -- Primer bit de datos
        wait for CLK_PERIOD;
        sda_internal <= '0'; -- Segundo bit de datos
        wait for CLK_PERIOD;
        sda_internal <= 'Z'; -- Liberar SDA

        -- Finaliza la simulación
        wait for 5 us;
        report "FIN CONTROLADO DE LA SIMULACION" severity failure;
    end process stimulus;

end sim;
