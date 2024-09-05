library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rgb_controller is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        RX : in std_logic;
        PWM_RED_OUT : out std_logic;
        PWM_GREEN_OUT : out std_logic;
        PWM_BLUE_OUT : out std_logic
    );
end test_rgb_controller;

architecture Behavorial of test_rgb_controller is



end Behavorial;