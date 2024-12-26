library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity variable_blink_tb is
end variable_blink_tb;

architecture sim of variable_blink_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component variable_blink
        port(
            CLK : in std_logic;
            RST : in std_logic;
            LED : out std_logic
        );
    end component;

    -- Testbench signals
    signal CLK_tb : std_logic := '0';
    signal RST_tb : std_logic := '0';
    signal LED_tb : std_logic;

    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz clock

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: variable_blink
        port map(
            CLK => CLK_tb,
            RST => RST_tb,
            LED => LED_tb
        );

    -- Clock generation
    CLK_process : process
    begin
        while true loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initialize inputs
        RST_tb <= '1';
        wait for 100 ns;
        
        RST_tb <= '0';
        wait for 500 ms; -- Simulate for 500 ms to observe multiple LED states

        -- Finish simulation
        wait for 7000ms;
        report "FIN CONTROLADO DE LA SIMULACION" severity failure;
    end process;

end sim;
