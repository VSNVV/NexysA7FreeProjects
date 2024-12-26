library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_controller is
    port(
        RST : in std_logic;
        CLK : in std_logic;
        MODE : in std_logic;
        PWM_R1 : out std_logic_vector(7 downto 0);
        PWM_G1 : out std_logic_vector(7 downto 0);
        PWM_B1 : out std_logic_vector(7 downto 0);
        PWM_R2 : out std_logic_vector(7 downto 0);
        PWM_G2 : out std_logic_vector(7 downto 0);
        PWM_B2 : out std_logic_vector(7 downto 0)
    );
end rgb_controller;

architecture rtl of rgb_controller is
-- Declaración de Sennales y/o Constantes
constant CLKDIV : integer := 20000000;
type FSM is (Static, Blink, StaticChanged, BlinkChanged);
signal actual_state : FSM;
signal r1, g1, b1, r2, g2, b2 : std_logic_vector(7 downto 0);
signal prescaler_counter : integer range 0 to CLKDIV - 1;
signal prescaler_out : std_logic;

begin
    FiniteStateMachine: process(CLK, actual_state)
    begin
        if RST = '1' then
            actual_state <= Static;
        elsif rising_edge(CLK) then
            case actual_state is
                when Static =>
                    if MODE = '1' then
                        actual_state <= Blink;
                    else
                        actual_state <= Static;
                    end if;
                when Blink =>
                    if MODE = '1' then
                        actual_state <= StaticChanged;
                    else
                        actual_state <= Blink;
                    end if;
                when StaticChanged =>
                    if MODE = '1' then
                        actual_state <= BlinkChanged;
                    else
                        actual_state <= StaticChanged;
                    end if;
                when BlinkChanged =>
                    if MODE = '1' then
                        actual_state <= Static;
                    else
                        actual_state <= BlinkChanged;
                    end if;
            end case;
        end if;
    end process FiniteStateMachine;

    Comparator: process(actual_state)
    begin
        if (actual_state = Static) or (actual_state = Blink) then
            -- Led 1
            r1 <= (others => '1');
            g1 <= (others => '0');
            b1 <= (others => '0');
            -- Led 2
            r2 <= (others => '0');
            g2 <= (others => '1');
            b2 <= (others => '0');
        else
            -- Led 1
            r1 <= (others => '0');
            g1 <= (others => '1');
            b1 <= (others => '0');
            -- Led 2
            r2 <= (others => '1');
            g2 <= (others => '0');
            b2 <= (others => '0');
        end if;
    end process Comparator;

    Prescaler: process(RST, CLK)
    begin
        if RST = '1' then
            prescaler_counter <= 0;
            prescaler_out <= '0';
        elsif rising_edge(CLK) then
            if prescaler_counter = CLKDIV - 1 then
                prescaler_out <= not prescaler_out;
                prescaler_counter <= 0;
            else
                prescaler_counter <= prescaler_counter + 1;
            end if;
        end if;
    end process Prescaler;

    RegisterOut: process(RST, CLK, actual_state, prescaler_out, r1, g1, b1, r2, g2, b2)
    begin
        if RST = '1' then
            PWM_R1 <= (others => '0');
            PWM_G1 <= (others => '0');
            PWM_B1 <= (others => '0');
            PWM_R2 <= (others => '0');
            PWM_G2 <= (others => '0');
            PWM_B2 <= (others => '0');
        elsif rising_edge(CLK) then
            if (actual_state = Static) or (actual_state = StaticChanged) then
                PWM_R1 <= r1;
                PWM_G1 <= g1;
                PWM_B1 <= b1;
                PWM_R2 <= r2;
                PWM_G2 <= g2;
                PWM_B2 <= b2;
            else
                if prescaler_out = '1' then
                    PWM_R1 <= r1;
                    PWM_G1 <= g1;
                    PWM_B1 <= b1;
                    PWM_R2 <= r2;
                    PWM_G2 <= g2;
                    PWM_B2 <= b2;
                else
                    PWM_R1 <= (others => '0');
                    PWM_G1 <= (others => '0');
                    PWM_B1 <= (others => '0');
                    PWM_R2 <= (others => '0');
                    PWM_G2 <= (others => '0');
                    PWM_B2 <= (others => '0');
                end if;
            end if;
        end if;
    end process RegisterOut;

end rtl;