library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkgen10kHz is
    port(
        RST : in std_logic;
        CLK_IN : in std_logic;
        CLK_OUT : out std_logic
    );
end clkgen10kHz;

architecture rtl of clkgen10kHz is
-- Declaracion de Sennales y/o Constantes
constant clk_div : integer := 10000;
signal prescaler_counter : integer range 0 to clk_div - 1;
signal clk_out_reg : std_logic;

begin
    Prescaler: process(RST, CLK_IN)
    begin
        if RST = '1' then
            prescaler_counter <= 0;
            clk_out_reg <= '0';
        elsif rising_edge(CLK_IN) then
            if prescaler_counter = clk_div - 1 then
                clk_out_reg <= not clk_out_reg;
                prescaler_counter <= 0;
            else
                prescaler_counter <= prescaler_counter + 1;
            end if;
        end if;
        CLK_OUT <= clk_out_reg;
    end process Prescaler;
end rtl;