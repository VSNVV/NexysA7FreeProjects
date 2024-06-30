library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_led_controller is
    port(
       CLK          : in std_logic;
       RST          : in std_logic;
       RED_IN       : in std_logic_vector(7 downto 0);
       GREEN_IN     : in std_logic_vector(7 downto 0);
       BLUE_IN      : in std_logic_vector(7 downto 0);
       CHANGE_STATE : in std_logic;
       PWM_RED      : out std_logic_vector(7 downto 0);
       PWM_GREEN    : out std_logic_vector(7 downto 0);
       PWM_BLUE     : out std_logic_vector(7 downto 0)
    );
end rgb_led_controller;

architecture rtl of rgb_led_controller is
-- Declaracion de Sennales y/o Constantes
type FSM is (Idle, Red, Green, Blue, Fade);
signal ActualState : FSM; -- Sennal del estado en el que se encuentra la Maquina de Estados
signal RegRedIn, RegGreenIn, RegBlueIn : std_logic_vector(2 downto 0); -- Sennales de salida del Registro de entrada

begin
    FinitStateMachine: process(CLK, RST, CHANGE_STATE, ActualState)
    begin
        if RST = '1' then
            ActualState <= Idle;
        elsif rising_edge(CLK) then
            case ActualState is
                when Idle =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Red;
                    else
                        ActualState <= Idle;
                    end if;
                when Red =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Green;
                    else
                        ActualState <= Red;
                    end if;
                when Green =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Blue;
                    else
                        ActualState <= Green;
                    end if;
                when Blue =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Fade;
                    else
                        ActualState <= Blue;
                    end if;
                when Fade =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Idle;
                    else
                        ActualState <= Fade;
                    end if;
                when others => ActualState <= Idle;
            end case;
        end if;
    end process FinitStateMachine;e

    RegIn: process(CLK, RST, RED_IN)
    begin
        if RST = '1' then
            RegRedIn <= (others => '0');
            RegGreenIn <= (others => '0');
            RegBlueIn <= (others => '0');
        elsif rising_edge(CLK) then
            RegRedIn <= RED_IN;
            RegGreenIn <= GREEN_IN;
            RegBlueIn <= BLUE_IN;
        end if;
    end process RegIn;

    

    
end rtl;