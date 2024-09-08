library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_ascii_decoder is
    port(
        CLK : in std_logic;
        RST : in std_logic;
        RX : in std_logic;
        RESULT : out std_logic_vector(7 downto 0);
        ERROR_RECEP : out std_logic
    );
end test_ascii_decoder;

architecture Behavorial of test_ascii_decoder is
-- Declaracion de Sennales y/o Constantes
signal data_rx : std_logic_vector(7 downto 0);
signal data_rx_ok : std_logic;


begin
    U_RECEIVER: entity work.receiver
    port map(
        clk => CLK,
        rst => RST,
        rx => RX,
        dato_rx => data_rx,
        error_recep => ERROR_RECEP,
        dato_rx_ok => data_rx_ok
    );

    U_ASCII_DECODER: entity work.ascii_decoder
    port map(
        CLK => CLK,
        DATA_RX => data_rx,
        DATA_RX_OK => data_rx_ok,
        RESULT => RESULT
    );
end Behavorial;