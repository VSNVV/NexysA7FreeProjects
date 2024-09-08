library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rgb_controller is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        RX : in std_logic;
        ERROR_RECEP : out std_logic;
        PWM_RED_OUT1 : out std_logic;
        PWM_GREEN_OUT1 : out std_logic;
        PWM_BLUE_OUT1 : out std_logic;
        PWM_RED_OUT2 : out std_logic;
        PWM_GREEN_OUT2 : out std_logic;
        PWM_BLUE_OUT2 : out std_logic
    );
end test_rgb_controller;

architecture Behavorial of test_rgb_controller is
-- Declaracion de Sennales
signal data_rx_reg : std_logic_vector(7 downto 0);
signal data_rx_ok_reg : std_logic;
signal r, g, b : std_logic_vector(7 downto 0);
signal enter_debounced : std_logic; -- Sennal de Enter de un solo ciclo de reloj
signal enter_in : std_logic;

begin

    U_RECEIVER: entity work.receiver
    port map(
        clk => CLK,
        RST => RST,
        rx => RX,
        dato_rx => data_rx_reg,
        error_recep => ERROR_RECEP,
        DATO_RX_OK => data_rx_ok_reg
    );

    U_COMPARATOR_ENTER : entity work.comparator_enter
    port map(
        CLK => CLK,
        DATA_RX => data_rx_reg,
        DATA_RX_OK => data_rx_ok_reg,
        RESULT => enter_in
    );

    U_DEBOUNCER_ENTER: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => enter_in,
        pls_o => enter_debounced
    );

    U_RGB_CONTROLLER: entity work.rgb_controller
    port map(
        RST => RST,
        CLK => CLK,
        DATA_RX => data_rx_reg,
        DATA_RX_OK => data_rx_ok_reg,
        ENTER => enter_debounced,
        R => r,
        G => g,
        B => b
    );

    U_PWM_RED1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => r,
        PWM_OUT => PWM_RED_OUT1
    );

    U_PWM_GREEN1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => g,
        PWM_OUT => PWM_GREEN_OUT1
    );

    U_PWM_BLUE1: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => b,
        PWM_OUT => PWM_BLUE_OUT1
    );

    U_PWM_RED2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => r,
        PWM_OUT => PWM_RED_OUT2
    );

    U_PWM_GREEN2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => g,
        PWM_OUT => PWM_GREEN_OUT2
    );

    U_PWM_BLUE2: entity work.pwm_module
    port map(
        CLK => CLK,
        DATA => b,
        PWM_OUT => PWM_BLUE_OUT2
    );

end Behavorial;