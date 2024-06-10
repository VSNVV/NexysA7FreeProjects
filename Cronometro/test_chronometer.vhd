library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_chronometer is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      PAUSE_SWITCH : in std_logic;
      SEG_AG     : out  std_logic_vector(6 downto 0);
      AND_70     : out  std_logic_vector(7 downto 0));
end test_chronometer;

architecture Behavorial of test_chronometer is
-- Declaracion de Sennales y constantes
signal pause_button_debounced : std_logic;
signal chronometer_out : std_logic_vector(31 downto 0);
signal chronometer_out_ok : std_logic;

begin

  U_CHRONOMETER: entity work.chronometer
  port map(
    RST => RST,
    CLK => CLK,
    PAUSE => PAUSE_SWITCH,
    DATA_OUT => chronometer_out,
    DATA_OUT_OK => chronometer_out_ok
  );

  U_DISPLAY_CONTROLLER: entity work.display_number_controller
  port map(
    RST => RST,
    CLK => CLK,
    NUMBER_IN => chronometer_out,
    NUMBER_OK => chronometer_out_ok,
    SEG_AG => SEG_AG,
    AND_70 => AND_70
  );
end Behavorial;