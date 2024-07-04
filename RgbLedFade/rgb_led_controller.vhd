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
constant CLKDIV : integer := 300000;
type FSM is (Idle, Red, Green, Blue, Fade);
signal ActualState : FSM; -- Sennal del estado en el que se encuentra la Maquina de Estados
signal PR_FC : std_logic; -- Sennal de fin de cuenta del Prescaler
signal FadeOut : std_logic_vector(23 downto 0); -- Sennal de salida del Fade

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

    FadeModule: process(RST, CLK, PR_FC)
    variable red : unsigned(7 downto 0) := (others => '1');
    variable green : unsigned(7 downto 0) := (others => '0');
    variable blue : unsigned(7 downto 0) := (others => '0');
    variable step : integer range 0 to 5;
    begin
        if RST = '1' then
            red := (others => '1');
            green := (others => '0');
            blue := (others => '0');
            step := 0;
            FadeOut <= (others => '0');
        elsif rising_edge(CLK) then
            if PR_FC = '1' then
                case step is
                    when 0 =>
                        -- Mantenemos el rojo al maximo mientras sube el verde
                        red := (others => '1');
                        green := green + 1;
                        blue := (others => '0');
                        if green = 255 then
                            step := step + 1;
                        end if;
                    when 1 =>
                        -- Mantenemos el verde al maximo mientras baja el rojo
                        red := red - 1;
                        green := (others => '1');
                        blue := (others => '0');
                        if red = 0 then
                            step := step + 1;
                        end if;
                    when 2 =>
                        -- Mantenemos el verde al maximo mientras sube el azul
                        red := (others => '0');
                        green := (others => '1');
                        blue := blue + 1;
                        if blue = 255 then
                            step := step + 1;
                        end if;
                    when 3 =>
                        -- Mantenemos el azul al maximo mientras baja el verde
                        red := (others => '0');
                        green := green - 1;
                        blue := (others => '1');
                        if green = 0 then
                            step := step + 1;
                        end if;
                    when 4 =>
                        -- Mantenemos el azul al maximo mientras sube el rojo
                        red := red + 1;
                        green := (others => '0');
                        blue := (others => '1');
                        if red = 255 then
                            step := step + 1;
                        end if;
                    when 5 =>
                        -- Mantenemos el rojo al maximo mientras baja el azul
                        red := (others => '1');
                        green := (others => '0');
                        blue := blue - 1;
                        if blue = 0 then
                            step := 0;
                        end if;
                end case;
                FadeOut <= std_logic_vector(red) & std_logic_vector(green) & std_logic_vector(blue); 
            end if;
        end if;
    end process FadeModule;

    Setter: process(CLK, ActualState, FadeOut)
    begin
        if rising_edge(CLK) then
            case ActualState is
                when Idle =>
                    PWM_RED <= (others => '0');
                    PWM_GREEN <= (others => '0');
                    PWM_BLUE <= (others => '0');
                when Red =>
                    PWM_RED <= (others => '1');
                    PWM_GREEN <= (others => '0');
                    PWM_BLUE <= (others => '0');
                when Green =>
                    PWM_RED <= (others => '0');
                    PWM_GREEN <= (others => '1');
                    PWM_BLUE <= (others => '0');
                when Blue =>
                    PWM_RED <= (others => '0');
                    PWM_GREEN <= (others => '0');
                    PWM_BLUE <= (others => '1');
                when others =>
                    PWM_RED <= FadeOut(23 downto 16);
                    PWM_GREEN <= FadeOut(15 downto 8);
                    PWM_BLUE <= FadeOut(7 downto 0);
            end case;
        end if;
    end process Setter;
end rtl;