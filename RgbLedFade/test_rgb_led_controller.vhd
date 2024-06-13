library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rgb_led_controller is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       COLOR_SET : in std_logic_vector(2 downto 0);
       COLOR_SET_OK : in std_logic;
       RED_LED1 : out std_logic;
       GREEN_LED1 : out std_logic;
       BLUE_LED1 : out std_logic;
       RED_LED2 : out std_logic;
       GREEN_LED2 : out std_logic;
       BLUE_LED2 : out std_logic
    );
end test_rgb_led_controller;

architecture Behavorial of test_rgb_led_controller is
-- Declaracion de Sennales y/o Constantes
signal red_rgb_controller, green_rgb_controller, blue_rgb_controller : std_logic_vector(7 downto 0);
signal color_set_ok_debounced : std_logic;

begin
    U_DEBOUNCER: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => COLOR_SET_OK,
        pls_o => color_set_ok_debounced
    );

    U_RGB_LED_CONTROLLER: entity work.rgb_led_controller
    port map(
        CLK => CLK,
        RST => RST,
        COLOR_SET => COLOR_SET,
        COLOR_SET_OK => color_set_ok_debounced,
        PWM_RED => red_rgb_controller,
        PWM_GREEN => green_rgb_controller,
        PWM_BLUE => blue_rgb_controller
    );

    U_PWM_RED_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => red_rgb_controller,
        PWM_OUT => RED_LED1
    );

    U_PWM_GREEN_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => green_rgb_controller,
        PWM_OUT => GREEN_LED1
    );

    U_PWM_BLUE_LED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => blue_rgb_controller,
        PWM_OUT => BLUE_LED1
    );

    U_PWM_RED_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => red_rgb_controller,
        PWM_OUT => RED_LED2
    );

    U_PWM_GREEN_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => green_rgb_controller,
        PWM_OUT => GREEN_LED2
    );

    U_PWM_BLUE_LED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => blue_rgb_controller,
        PWM_OUT => BLUE_LED2
    );
end Behavorial;