library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_system is
    port (
      CLK         : in  std_logic;
      RST         : in  std_logic;
      RX          : in  std_logic;
      SEG_AG      : out std_logic_vector(6 downto 0);
      AND_70      : out std_logic_vector(7 downto 0);
      ERROR_RECEP : out std_logic);
end top_system;

architecture Behavorial of top_system is
-- Declaracion de Sennales
signal DATO_RX : std_logic_vector(7 downto 0);
signal DATO_RX_OK : std_logic;
begin
    U_RECEIVER: entity work.receiver
    port map(
        RX => RX,
        CLK => CLK,
        RST => RST,
        dato_rx => DATO_RX,
        dato_rx_ok => DATO_RX_OK,
        error_recep => ERROR_RECEP
    );

    U_DISPLAY_LETTER_CONTROLLER: entity work.display_letter_controller
    port map(
        RST => RST,
        CLK => CLK,
        NUMBER_IN => DATO_RX,
        NUMBER_OK => DATO_RX_OK,
        SEG_AG => SEG_AG,
        AND_70 => AND_70
    );
end Behavorial;