library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity button_game is
  port(RST        : in  std_logic;
       CLK        : in  std_logic; 
       BUTTONJ1   : in  std_logic;
       BUTTONJ2   : in  std_logic;
       AND_70     : out std_logic_vector(7 downto 0);
       SEG_AG     : out std_logic_vector(6 downto 0));
end button_game;

architecture rtl of button_game is
-- Declaracion de Sennales
--constant dispAux : std_logic_vector(3 downto 0) := "0000";
constant CTE_PRESCALER : integer := 5e6;
signal BUTTONJ1_reg : std_logic; -- Sennal para controlar el antirebote del boton del jugador 1
signal BUTTONJ2_reg : std_logic; -- Sennal para controlar el antirebote del boton del jugador 2
signal scoreJ1_0 : std_logic_vector(3 downto 0); -- Sennal que contiene la puntuacion del jugador 1 (unidades)
signal scoreJ1_1 : std_logic_vector(3 downto 0); -- Sennal que contiene la puntuacion del jugador 1 (decenas)
signal scoreJ2_0 : std_logic_vector(3 downto 0); -- Sennal que contiene la puntuacion del jugador 2 (unidades)
signal scoreJ2_1 : std_logic_vector(3 downto 0); -- Sennal que contiene la puntuacion del jugador 2 (decenas)
signal MuxOut : std_logic_vector(3 downto 0); -- Sennal de salida del Multiplexor
signal CntOut : std_logic_vector(2 downto 0); -- Sennal de salida del contador (que actua como selector en el Multiplexor)
signal Dec4To7Seg : std_logic_vector(6 downto 0); -- Sennal de salida del Decodificador de 4 bits a 7 segmentos
signal Dec3To8Out : std_logic_vector(7 downto 0); -- Sennal de salida del Decodificador de 3 bits a 8
signal PROut : std_logic; -- Sennal de salida del Prescaler (fin de cuenta)

begin
    process(BUTTONJ1, RST) -- Proceso que modela el circuito combinacional que cuenta las pulsaciones del jugador 1
    -- Declaracion de variables
    variable scoreJ1_decenas : unsigned(3 downto 0) := (others => '0');
    variable scoreJ1_unidades : unsigned(3 downto 0) := (others => '0');
    begin
        if RST = '1' then
            scoreJ1_decenas := (others => '0');
            scoreJ1_unidades := (others => '0');
        elsif(BUTTONJ1 = '1' and BUTTONJ1_reg = '0') then
            if(scoreJ1_decenas < 3) then
                if scoreJ1_unidades = 9 then
                    scoreJ1_decenas := scoreJ1_decenas + 1;
                    scoreJ1_unidades := (others => '0');
                else
                    scoreJ1_unidades := scoreJ1_unidades + 1;
                end if;
            end if;
        end if;
        scoreJ1_0 <= std_logic_vector(scoreJ1_unidades);
        scoreJ1_1 <= std_logic_vector(scoreJ1_decenas);
        BUTTONJ1_reg <= BUTTONJ1;
    end process;

    process(BUTTONJ2, RST) -- Proceso que modela el circuito combinacional que cuenta las pulsaciones del jugador 2
    -- Declaracion de variables
    variable scoreJ2_decenas : unsigned(3 downto 0) := (others => '0');
    variable scoreJ2_unidades : unsigned(3 downto 0) := (others => '0');
    begin
        if RST = '1' then
            scoreJ2_decenas := (others => '0');
            scoreJ2_unidades := (others => '0');
        elsif(BUTTONJ2 = '1' and BUTTONJ2_reg = '0') then
            if(scoreJ2_decenas < 3) then
                if scoreJ2_unidades = 9 then
                    scoreJ2_decenas := scoreJ2_decenas + 1;
                    scoreJ2_unidades := (others => '0');
                else
                    scoreJ2_unidades := scoreJ2_unidades + 1;
                end if;
            end if;
        end if;
        scoreJ2_0 <= std_logic_vector(scoreJ2_unidades);
        scoreJ2_1 <= std_logic_vector(scoreJ2_decenas);
        BUTTONJ2_reg <= BUTTONJ2;
    end process;

    process(scoreJ1_0, scoreJ1_1, scoreJ2_0, scoreJ2_1, CntOut)
    -- Declaracion de variables
    begin
        case CntOut is
            when "000" => MuxOut <= scoreJ1_0;
            when "001" => MuxOut <= scoreJ1_1;
            when "110" => MuxOut <= scoreJ2_0;
            when "111" => MuxOut <= ScoreJ2_1;
            when others => MuxOut <= "1111";
        end case;
    end process;

    process(MuxOut) -- Decodificador 4 bit - 7seg
    begin
        case(MuxOut) is -- gfedcba
            when "0000" => Dec4To7Seg <= "1000000";
            when "0001" => Dec4To7Seg <= "1111001";
            when "0010" => Dec4To7Seg <= "0100100";
            when "0011" => Dec4To7Seg <= "0110000";
            when "0100" => Dec4To7Seg <= "0011001";
            when "0101" => Dec4To7Seg <= "0010010";
            when "0110" => Dec4To7Seg <= "0000010";
            when "0111" => Dec4To7Seg <= "1111000";
            when "1000" => Dec4To7Seg <= "0000000";
            when "1001" => Dec4To7Seg <= "0011000";
            when others => Dec4To7Seg <= "1111111";
        end case;
    end process;

    process(Dec4To7Seg, CLK, RST)
    begin
        if RST = '1' then
            SEG_AG <= (others => "1111111");
        elsif CLK'event and CLK = '1' then
            SEG_AG <= Dec4To7Seg;
        end if;
    end process;

    process(CLK, RST) -- Proceso que modela el Prescaler
    -- Declaracion de variables
    variable cuenta : integer := 0;
    begin
        if RST = '1' then
            cuenta := 0;
            PROut <= '0';
        elsif CLK'event and CLK = '1' then
            if cuenta = CTE_PRESCALER then
                cuenta := 0;
                PROut <= '1';
            else
                cuenta := cuenta + 1;
                PROut <= '0';
            end if;
        end if;
    end process;

    process(PROut, CLK, RST) -- Proceso que modela el Contador de 3 bits
    -- Declaracion de variables
    variable cuenta : unsigned(2 downto 0) := (others => '0');
    begin
        if RST = '1' then
            cuenta := (others => '0');
        elsif CLK'event and CLK = '1' then
            if PROut = '1' then
                if cuenta = 7 then
                    cuenta := (others => '0');
                else
                    cuenta := cuenta + 1;
                end if;
            end if;
        end if;
        CntOut <= std_logic_vector(cuenta);
    end process;

    process(CntOut) -- Proceso que modela el Decodificador de 3 bits a 8 (AND_70)
    begin
        case CntOut is
            when "000" => Dec3To8Out <= "11111110";
            when "001" => Dec3To8Out <= "11111101";
            when "010" => Dec3To8Out <= "11111011";
            when "011" => Dec3To8Out <= "11110111";
            when "100" => Dec3To8Out <= "11101111";
            when "101" => Dec3To8Out <= "11011111";
            when "110" => Dec3To8Out <= "10111111";
            when "111" => Dec3To8Out <= "01111111";
            when others => Dec3To8Out <= "11111111";
        end case;
    end process;

    process(Dec3To8Out, CLK, RST) -- Proceso que modela el Registro de AND_70
    begin
        if RST = '1' then
            AND_70 <= "11111111"
        elsif CLK'event and CLK = '1' then
            AND_70 <= Dec3To8Out;
        end if;
    end process;

end rtl;