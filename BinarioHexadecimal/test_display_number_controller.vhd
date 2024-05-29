library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_display_number_controller is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      NUMBER_IN  : in  std_logic_vector(7 downto 0);
      NUMBER_OK  : in  std_logic;
      SEG_AG     : out  std_logic_vector(6 downto 0);
      AND_70     : out  std_logic_vector(7 downto 0));
end test_display_number_controller;

architecture Behavorial of test_display_number_controller is
signal load : std_logic;

begin
    U_DEBOUNCER: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => NUMBER_OK,
        pls_o => load
    );

    U_DISPLAY_NUMBER_CONTROLLER: entity work.display_number_controller
    port map(
        RST => RST,
        CLK => CLK,
        NUMBER_IN => NUMBER_IN,
        NUMBER_OK => load,
        SEG_AG => SEG_AG,
        AND_70 => AND_70
    );
end Behavorial;