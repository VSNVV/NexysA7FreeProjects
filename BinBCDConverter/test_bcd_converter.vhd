library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_bcd_converter is
  port(CLK        : in   std_logic;
    RST           : in   std_logic;
    BIN_NUM       : in   std_logic_vector(15 downto 0);
    BIN_NUM_OK    : in   std_logic;
    SEG_AG        : out  std_logic_vector(6 downto 0);
    AND_70        : out  std_logic_vector(7 downto 0));
end test_bcd_converter;

architecture Behavorial of test_bcd_converter is
-- Declaracion de Sennales
signal BcdConverterOut : std_logic_vector(31 downto 0);
signal BcdOk : std_logic;
signal bin_num_ok_debounced : std_logic;


begin
    U_DEBOUNCER: entity work.debouncer
    port map(
      CLK => CLK,
      sig_i => BIN_NUM_OK,
      pls_o => bin_num_ok_debounced
    );
    

    U_BIN_BCD_CONVERTER: entity work.bin_bcd_converter
    port map(
      CLK => CLK,
      RST => RST,
      BIN_NUM => BIN_NUM,
      BIN_NUM_OK => bin_num_ok_debounced,
      BCD_OUT => BcdConverterOut,
      BCD_OUT_OK => BcdOk
    );

    U_DISPLAY_NUMBER_CONTROLLER: entity work.display_number_controller
    port map(
      CLK => CLK,
      RST => RST,
      NUMBER_IN => BcdConverterOut,
      NUMBER_OK => BcdOk,
      SEG_AG => SEG_AG,
      AND_70 => AND_70
    );

end Behavorial;