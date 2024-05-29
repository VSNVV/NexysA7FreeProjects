library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_system is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      BUTTONJ1   : in  std_logic;
      BUTTONJ2   : in  std_logic;
      SEG_AG   : out std_logic_vector(6 downto 0);
      AND_70 : out std_logic_vector(7 downto 0);
      END_GAME : out std_logic);
end top_system;

architecture Behavorial of top_system is
-- Declaracion de Sennales
signal buttonj1_ok, buttonj2_ok : std_logic;
signal NUM_IN : std_logic_vector(31 downto 0);
signal NUM_OK : std_logic;
begin
    U_DEBOUNCER_J1: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => BUTTONJ1,
        pls_o => buttonj1_ok
    );

    U_DEBOUNCER_J2: entity work.debouncer
    port map(
        CLK => CLK,
        sig_i => BUTTONJ2,
        pls_o => buttonj2_ok
    );

    U_COUNT_PULS: entity work.count_puls
    port map(
        RST => RST,
        CLK => CLK,
        BUTTONJ1 => buttonj1_ok,
        BUTTONJ2 => buttonj2_ok,
        PULS_OUT => NUM_IN,
        PULS_OUT_OK => NUM_OK,
        END_GAME => END_GAME
    );

    U_DISPLAY_NUMBER_CONTROLLER: entity work.display_number_controller
    port map(
        RST => RST,
        CLK => CLK,
        NUMBER_IN => NUM_IN,
        NUMBER_OK => NUM_OK,
        SEG_AG => SEG_AG,
        AND_70 => AND_70
    );
end Behavorial;


