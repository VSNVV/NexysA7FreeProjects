library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity variable_blink is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        LED : out std_logic
    );
end variable_blink;

architecture rtl of variable_blink is
-- Declaracion de Sennales y/o Constantes
constant prescaler_time : integer := 500000000; -- 500 millones de CLK son 5 segundos
signal timer_prescaler : integer range 0 to prescaler_time; -- Sennal que cuenta los CLK de TimerPrescaler
signal timer_prescaler_out : std_logic; -- Sennal de salida del TimerPrescaler
signal blink_rate : integer range 0 to 100000000; -- Sennal que cuenta en CounterBlink
signal prescaler_blink : integer range 0 to 100000000; -- Sennal que cuenta los CLK de PrescalerBlink
signal prescaler_blink_out : std_logic; -- Sennal de salida de PrescalerBlink
type FSM is (Blink1, Blink2, Blink3, Blink4, Blink5); -- Estados de la maquina de estados
signal actual_state : FSM; -- Sennal de la maquina de estados
signal reversed : std_logic; -- Sennal que indica si el cambio de estados esta revertido o no

begin
    FiniteStateMachine: process(CLK, RST, actual_state, timer_prescaler_out)
    begin
        if RST = '1' then
            actual_state <= Blink1;
            reversed <= '0';
        elsif rising_edge(CLK) then
            case actual_state is
                when Blink1 =>
                    reversed <= '0';
                    blink_rate <= 100000000; -- Blink del LED cada segundo
                    if timer_prescaler_out = '1' then
                        actual_state <= Blink2;
                    else
                        actual_state <= Blink1;
                    end if;
                when Blink2 =>
                    blink_rate <= 80000000; -- Blink del LED cada 0.8 segundos
                    if timer_prescaler_out = '1' then
                        if reversed = '1' then
                            actual_state <= Blink1;
                        else
                            actual_state <= Blink3;
                        end if;
                    else
                        actual_state <= Blink2;
                    end if;
                when Blink3 =>
                    blink_rate <= 60000000; -- Blink del LED cada 0.6 segundos
                    if timer_prescaler_out = '1' then
                        if reversed = '1' then
                            actual_state <= Blink2;
                        else
                            actual_state <= Blink4;
                        end if;
                    else
                        actual_state <= Blink3;
                    end if;
                when Blink4 =>
                    blink_rate <= 40000000; -- Blink del LED cada 0.4 segundos
                    if timer_prescaler_out = '1' then
                        if reversed = '1' then
                            actual_state <= Blink3;
                        else
                            actual_state <= Blink5;
                        end if;
                    else
                        actual_state <= Blink4;
                    end if;
                when Blink5 =>
                    reversed <= '1';
                    blink_rate <= 20000000; -- Blink del LED cada 0.2 segundos
                    if timer_prescaler_out = '1' then
                        actual_state <= Blink4;
                    else
                        actual_state <= Blink5;
                    end if;
                when others =>
                    actual_state <= Blink1;
            end case;
        end if;
    end process FiniteStateMachine;
    
    TimePrescaler: process(CLK, RST, timer_prescaler)
    begin
        if RST = '1' then
            timer_prescaler <= 0;
            timer_prescaler_out <= '0';
        elsif rising_edge(CLK) then
            if timer_prescaler < prescaler_time then
                timer_prescaler <= timer_prescaler + 1;
                timer_prescaler_out <= '0';
            else
                timer_prescaler <= 0;
                timer_prescaler_out <= '1';
            end if;
        end if;
    end process TimePrescaler;

    PrescalerBlink: process(CLK, RST, blink_rate, timer_prescaler_out, prescaler_blink)
    begin
        if RST = '1' then
            prescaler_blink <= 0;
            prescaler_blink_out <= '0';
        elsif rising_edge(CLK) then
            if timer_prescaler_out = '1' then
                prescaler_blink <= 0;
                prescaler_blink_out <= '0';
            else
                if prescaler_blink < blink_rate then
                    prescaler_blink <= prescaler_blink + 1;
                    prescaler_blink_out <= '0';
                else
                    prescaler_blink <= 0;
                    prescaler_blink_out <= '1';
                end if;
            end if;
        end if;
    end process PrescalerBlink;

    RegisterOut: process(CLK, prescaler_blink_out)
    variable led_aux : std_logic;
    begin
        if RST = '1' then
            led_aux := '0';
        elsif rising_edge(CLK) then
            if prescaler_blink_out = '1' then
                led_aux := not led_aux;
                LED <= led_aux;
            end if;
        end if;
    end process RegisterOut;

    
end rtl;