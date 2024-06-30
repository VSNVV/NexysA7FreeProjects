library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_module is
    port(
       CLK : in std_logic;
       DATA : in std_logic_vector(7 downto 0); -- Numero a modular
       PWM_OUT : out std_logic -- Salida del PWM
    );
end pwm_module;

architecture rtl of pwm_module is
-- Declaracion de Sennales y/o Constantes
-- Probar luminosidad con el Prescaler
signal prescalerCnt : unsigned(7 downto 0); -- Sennal que determina la cuenta del prescaler

begin
    Prescaler: process(CLK)
    begin
        if rising_edge(CLK) then
            prescalerCnt <= prescalerCnt + 1;
        end if;
    end process Prescaler;

    Comparator: process(DATA, prescalerCnt)
    begin
        if prescalerCnt < unsigned(DATA) then
            PWM_OUT <= '1';
        else
            PWM_OUT <= '0';
        end if;
    end process Comparator;
end rtl;