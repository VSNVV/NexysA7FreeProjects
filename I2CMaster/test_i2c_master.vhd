library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_i2c_master is
    port(
        RST : in std_logic;
        CLK : in std_logic;
        SDA : inout std_logic;
        SCL : out std_logic;
        ACK_STATE : out std_logic;
        DATA : out std_logic_vector(7 downto 0)
    );
end test_i2c_master;

architecture Behavorial of test_i2c_master is
-- Declaraciones de Sennales y/o Constantes
signal clk_10_khz : std_logic;

begin
    U_CLKGEN10KHZ : entity work.clkgen10kHz
    port map(
        RST => RST,
        CLK_IN => CLK,
        CLK_OUT => clk_10_khz
    );

    U_I2C_MASTER: entity work.i2c_master
    port map(
        RST => RST,
        CLK => clk_10_khz,
        SDA => SDA,
        SCL => SCL,
        ACK_STATE => ACK_STATE,
        DATA => DATA
    );
end Behavorial;