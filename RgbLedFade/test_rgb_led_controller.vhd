library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rgb_led_controller is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        CHANGE_COLOR : in std_logic;
        PWM_RED_LED1 : out std_logic;
        PWM_GREEN_LED1 : out std_logic;
        PWM_BLUE_LED1 : out std_logic;
        PWM_RED_LED2 : out std_logic;
        PWM_GREEN_LED2 : out std_logic;
        PWM_BLUE_LED2 : out std_logic
    );
end test_rgb_led_controller;

architecture Behavorial of test_rgb_led_controller is
-- Declaracion de Sennales y constantes
signal reg_pwm_red, reg_pwm_green, reg_pwm_blue : std_logic_vector(7 downto 0);
signal change_color_debounced : std_logic;

begin

    U_DEBOUNCER: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => CHANGE_COLOR,
        pls_o => change_color_debounced
    );

    U_RGB_LED_CONTROLLER: entity work.rgb_led_controller
    port map(
        CLK => CLK,
        RST => RST,
        CHANGE_STATE => change_color_debounced,
        PWM_RED => reg_pwm_red,
        PWM_GREEN => reg_pwm_green,
        PWM_BLUE => reg_pwm_blue
    );

    U_PWM_RED_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_red,
        PWM_OUT => PWM_RED_LED1
    );

    U_PWM_GREEN_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_green,
        PWM_OUT => PWM_GREEN_LED1
    );

    U_PWM_BLUE_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_blue,
        PWM_OUT => PWM_BLUE_LED1
    );

    U_PWM_RED_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_red,
        PWM_OUT => PWM_RED_LED2
    );

    U_PWM_GREEN_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_green,
        PWM_OUT => PWM_GREEN_LED2
    );

    U_PWM_BLUE_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => reg_pwm_blue,
        PWM_OUT => PWM_BLUE_LED2
    );
end Behavorial;