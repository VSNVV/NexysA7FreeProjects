library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_guess_number is
    port(RST        : in  std_logic;
       CLK        : in  std_logic; 
       NUMBER_TO_GUESS : in std_logic_vector(7 downto 0);
       NUMBER_TO_GUESS_OK : in std_logic;
       GUESSER_NUMBER : in std_logic_vector(7 downto 0);
       GUESSER_NUMBER_OK : in std_logic;
       AND_70 : out std_logic_vector(7 downto 0);
       SEG_AG : out std_logic_vector(6 downto 0);
       BITS_EQUALS : out std_logic_vector(7 downto 0));
end test_guess_number;

architecture rtl of test_guess_number is
-- Declaracion de Sennales
signal load_number : std_logic;
signal load_guess : std_logic;
signal reg_number_to_guess_ok : std_logic;
signal reg_guesser_number_ok : std_logic;

begin
    process(CLK, RST)
    begin
        if RST = '1' then
            reg_number_to_guess_ok <= '0';
            reg_guesser_number_ok <= '0';
            load_number <= '0';
            load_guess <= '0';
        elsif CLK'event and CLK = '1' then
            reg_number_to_guess_ok <= NUMBER_TO_GUESS_OK;
            load_number <= (not reg_number_to_guess_ok) and NUMBER_TO_GUESS_OK; -- Esto controla que aunque se mantenga el boton de enviar, solo se envie una vez
            reg_guesser_number_ok <= GUESSER_NUMBER_OK;
            load_guess <= (not reg_guesser_number_ok) and GUESSER_NUMBER_OK;
        end if;
    end process;

    U_GUESS_NUMBER: entity work.guess_number
            port map (
                RST                 => RST,
                CLK                 => CLK,
                NUMBER_TO_GUESS     => NUMBER_TO_GUESS,
                NUMBER_TO_GUESS_OK  => load_number,
                GUESSER_NUMBER      => GUESSER_NUMBER,
                GUESSER_NUMBER_OK   => load_guess,
                SEG_AG              => SEG_AG,
                AND_70              => AND_70,
                BITS_EQUALS         => BITS_EQUALS);


end rtl;