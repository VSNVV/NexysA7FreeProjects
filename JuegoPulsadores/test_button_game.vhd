entity test_button_game is
    port(RST        : in  std_logic;
       CLK        : in  std_logic; 
       BUTTONJ1   : in  std_logic;
       BUTTONJ2   : in  std_logic;
       AND_70     : out std_logic_vector(7 downto 0);
       SEG_AG     : out std_logic_vector(6 downto 0));
end test_button_game;

architecture Behavioral of test_button_game is
-- Declaracion de Sennales

begin

U_BUTTON_GAME : entity work.guess_number
    port map (
        RST             => RST,
        CLK             => CLK,
        BUTTONJ1        => BUTTONJ1,
        BUTTONJ2        => BUTTONJ2,
        SEG_AG          => SEG_AG,
        AND_70          => AND_70);
        
end Behavioral;