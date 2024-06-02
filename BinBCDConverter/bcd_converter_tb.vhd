library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_converter_tb is

end bcd_converter_tb;

architecture sim of bcd_converter_tb is
-- Declaracion de Sennales
constant CNT1 : time := (4*50)*16*10ns;
signal RST_i : std_logic  := '1';
signal CLK_i : std_logic := '0';
signal BIN_NUM_i : std_logic_vector(15 downto 0);
signal BIN_NUM_OK_i : std_logic;
signal BCD_OUT_i : std_logic_vector(31 downto 0);
signal BCD_OUT_OK_i : std_logic;
signal SEG_AG_i : std_logic_vector(6 downto 0);
signal AND_70_i : std_logic_vector(7 downto 0);

begin

    U_BIN_BCD_CONVERTER: entity work.bin_bcd_converter
    port map(
      CLK => CLK_i,
      RST => RST_i,
      BIN_NUM => BIN_NUM_i,
      BIN_NUM_OK => BIN_NUM_OK_i,
      BCD_OUT => BCD_OUT_i,
      BCD_OUT_OK => BCD_OUT_OK_i
    );

    U_DISPLAY_NUMBER_CONTROLLER: entity work.display_number_controller
    port map(
      CLK => CLK_i,
      RST => RST_i,
      NUMBER_IN => BCD_OUT_i,
      NUMBER_OK => BCD_OUT_OK_i,
      SEG_AG => SEG_AG_i,
      AND_70 => AND_70_i
    );

    RST_i <= '0' after 123 ns;
    CLK_i <= not CLK_i after 5 ns;

    process

    procedure enviar_dato(dato : std_logic_vector(15 downto 0) ) is
    begin
      wait until CLK_i = '0';
      BIN_NUM_i    <= dato(15 downto 0);
      BIN_NUM_OK_i <= '1';
      wait until CLK_i = '0';
      BIN_NUM_OK_i <= '0';
      wait for CNT1;
      wait for 500 us;
    end enviar_dato;

    variable dato_1 : std_logic_vector(15 downto 0);
  begin  -- process
    wait for 333 ns;
    dato_1 := x"000E";                     --completar
    enviar_dato(dato_1);
    
    report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;

end sim;