library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_led_controller is
    port(
       CLK          : in std_logic;
       RST          : in std_logic;
       CHANGE_STATE : in std_logic;
       PWM_RED      : out std_logic_vector(7 downto 0);
       PWM_GREEN    : out std_logic_vector(7 downto 0);
       PWM_BLUE     : out std_logic_vector(7 downto 0)
    );
end rgb_led_controller;

architecture rtl of rgb_led_controller is
-- Declaracion de Sennales y/o Constantes
constant CLKDIV : integer := 7000;
type FSM is (Idle, Red, Green, Blue, Fade);
signal ActualState : FSM; -- Sennal del estado en el que se encuentra la Maquina de Estados
signal PR_FC : std_logic; -- Sennal de fin de cuenta del Prescaler

begin
    FiniteStateMachine: process(CLK, RST, ActualState, CHANGE_STATE)
    begin
        if RST = '1' then
            ActualState <= Idle;
        elsif rising_edge(CLK) then
            ActualState <= Idle; -- Por defecto, estaremos con los leds apagados
            case ActualState is
                when Idle =>
                    if CHANGE_STATE = '1' then
                        ActualState <= Idle;
                    else
                        ActualState <= Red;
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
                when others =>
                    ActualState <= Idle;
            end case;
        end if;
    end process FiniteStateMachine;

    Prescaler: process(CLK, RST)
    variable count : integer := 0;
    begin
        if RST = '1' then
            count := 0;
            PR_FC <= '0';
        elsif rising_edge(CLK) then
            if count = CLKDIV then
                count := 0;
                PR_FC <= '1';
            else
                count := count + 1;
                PR_FC <= '0';
            end if;
        end if;
    end process Prescaler;

    


    
end rtl;