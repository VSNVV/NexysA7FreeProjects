library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_led_controller is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       COLOR_SET : in std_logic_vector(2 downto 0); -- 100 Red, 010 Green, 001 Blue
       COLOR_SET_OK : in std_logic;
       PWM_RED : out std_logic_vector(7 downto 0);
       PWM_GREEN : out std_logic_vector(7 downto 0);
       PWM_BLUE : out std_logic_vector(7 downto 0)
    );
end rgb_led_controller;

architecture rtl of rgb_led_controller is
-- Declaracion de Sennales y/o Constantes
signal RegIn : std_logic_vector(2 downto 0); -- Sennal de salida del Registro de entrada

begin

    RegisterIn: process(CLK, RST, COLOR_SET, COLOR_SET_OK)
    begin
        if RST = '1' then
            RegIn <= (others => '0');
        elsif rising_edge(CLK) then
            if COLOR_SET_OK = '1' then
                RegIn <= COLOR_SET;
            end if;
        end if;
    end process RegisterIn;

    Comparator: process(RegIn)
    begin
        case RegIn is
            when "100" =>
                PWM_RED <= (others => '1');
                PWM_GREEN <= (others => '0');
                PWM_BLUE <= (others => '0');
            when "010" =>
                PWM_RED <= (others => '0');
                PWM_GREEN <= (others => '1');
                PWM_BLUE <= (others => '0');
            when "001" =>
                PWM_RED <= (others => '0');
                PWM_GREEN <= (others => '0');
                PWM_BLUE <= (others => '1');
            when "101" =>
                PWM_RED <= (others => '1');
                PWM_GREEN <= (others => '0');
                PWM_BLUE <= (others => '1');
            when "110" =>
                PWM_RED <= (others => '1');
                PWM_GREEN <= (others => '1');
                PWM_BLUE <= (others => '0');
            when "011" =>
                PWM_RED <= (others => '0');
                PWM_GREEN <= (others => '1');
                PWM_BLUE <= (others => '1');
            when "111" =>
                PWM_RED <= (others => '1');
                PWM_GREEN <= (others => '1');
                PWM_BLUE <= (others => '1');
            when others =>
                PWM_RED <= (others => '0');
                PWM_GREEN <= (others => '0');
                PWM_BLUE <= (others => '0');
        end case;
    end process Comparator;
end rtl;