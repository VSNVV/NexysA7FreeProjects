library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_xmas_lights is
    port(
        RST : in std_logic;
        CLK : in std_logic;
        MODE : in std_logic;
        PWM_RED1 : out std_logic;
        PWM_GREEN1 : out std_logic;
        PWM_BLUE1 : out std_logic;
        PWM_RED2 : out std_logic;
        PWM_GREEN2 : out std_logic;
        PWM_BLUE2 : out std_logic
    );
end test_xmas_lights;

architecture Behavorial of test_xmas_lights is
-- Declaracion de Sennales y/o Constantes
signal mode_button_debounced : std_logic;
signal pwm_red1_aux, pwm_green1_aux, pwm_blue1_aux, pwm_red2_aux, pwm_green2_aux, pwm_blue2_aux : std_logic_vector(7 downto 0);


begin
    U_DEBOUNCER: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => MODE,
        pls_o => mode_button_debounced
    );

    U_RGB_CONTROLLER: entity work.rgb_controller
    port map(
        RST => RST,
        CLK => CLK,
        MODE => mode_button_debounced,
        PWM_R1 => pwm_red1_aux,
        PWM_G1 => pwm_green1_aux,
        PWM_B1 => pwm_blue1_aux,
        PWM_R2 => pwm_red2_aux,
        PWM_G2 => pwm_green2_aux,
        PWM_B2 => pwm_blue2_aux
    );

    U_PWM_MODULE_RED_1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_red1_aux,
        PWM_OUT => PWM_RED1
    );

    U_PWM_MODULE_GREEN_1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_green1_aux,
        PWM_OUT => PWM_GREEN1
    );

    U_PWM_MODULE_BLUE_1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_blue1_aux,
        PWM_OUT => PWM_BLUE1
    );

    U_PWM_MODULE_RED_2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_red2_aux,
        PWM_OUT => PWM_RED2
    );

    U_PWM_MODULE_GREEN_2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_green2_aux,
        PWM_OUT => PWM_GREEN2
    );

    U_PWM_MODULE_BLUE_2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => pwm_blue2_aux,
        PWM_OUT => PWM_BLUE2
    );
end Behavorial;