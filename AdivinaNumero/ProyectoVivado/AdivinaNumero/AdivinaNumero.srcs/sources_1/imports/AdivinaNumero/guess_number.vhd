library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity guess_number is
  port(RST        : in  std_logic;
       CLK        : in  std_logic; 
       NUMBER_TO_GUESS : in std_logic_vector(7 downto 0);
       NUMBER_TO_GUESS_OK : in std_logic;
       GUESSER_NUMBER : in std_logic_vector(7 downto 0);
       GUESSER_NUMBER_OK : in std_logic;
       AND_70 : out std_logic_vector(7 downto 0);
       SEG_AG : out std_logic_vector(6 downto 0);
       BITS_EQUALS : out std_logic_vector(7 downto 0));
end guess_number;

architecture rtl of guess_number is
-- Declaracion de Sennales
constant CTE_PRESCALER : integer := 5e6;
signal reg_number_out : std_logic_vector(7 downto 0);
signal reg_guess_out : std_logic_vector(7 downto 0);
signal comparator_out : std_logic_vector(7 downto 0);
signal reg_guesser_number_ok : std_logic;
signal num_attempts : std_logic_vector(31 downto 0);
signal PROut : std_logic;
signal CntDisplayOut : std_logic_vector(2 downto 0);
signal Dec3To8Out : std_logic_vector(7 downto 0);
signal MuxDisplayOut : std_logic_vector(3 downto 0);
signal Dec4To7Seg : std_logic_vector(6 downto 0);

begin
    process(CLK, NUMBER_TO_GUESS, NUMBER_TO_GUESS_OK) -- Registro sincrono que envia el numero a adivinar a un comparador (combinacional)
    -- Declaracion de variables
    variable num : std_logic_vector(7 downto 0) := (others => '0');
    begin
        if RST = '1' then
            num := (others => '0');
        elsif CLK'event and CLK = '1' then
            if NUMBER_TO_GUESS_OK = '1' then
                num := NUMBER_TO_GUESS;
            end if;
        end if;
        reg_number_out <= num;
    end process;

    process(CLK, GUESSER_NUMBER, GUESSER_NUMBER_OK) -- Registro sincrono que envia el intento a un comparador (combinacional)
    -- Declaracion de variables
    variable guessing : std_logic_vector(7 downto 0) := (others => '0');
    begin
        if RST = '1' then
            guessing := (others => '0');
        elsif CLK'event and CLK = '1' then
            if GUESSER_NUMBER_OK = '1' then
                guessing := GUESSER_NUMBER;
            end if;
        end if;
        reg_guess_out <= guessing;
    end process;

    process(reg_number_out, reg_guess_out) -- Proceso que modela un comparador (combinacional) que compara el numero a adivinar, con el numero del que adivina
    -- Declaracion de variables
    variable cmp_aux : std_logic_vector(7 downto 0) := (others => '0');
    begin
        for index in reg_number_out'range loop
            if reg_number_out(index) = reg_guess_out(index) then
                cmp_aux(index) := '1';
            else
                cmp_aux(index) := '0';
            end if;
        end loop;
        comparator_out <= cmp_aux;
    end process;

    process(CLK, RST, comparator_out) -- Proceso que modela el Registro de salida sincrono de los bits iguales al numero a adivinar
    begin
        if RST = '1' then
            BITS_EQUALS <= (others => '0');
        elsif CLK'event and CLK = '1' then
            BITS_EQUALS <= comparator_out;
        end if;
    end process;

    process(GUESSER_NUMBER_OK, CLK, RST) -- Proceso que cuenta el numero de intentos y lo envía a un Multiplexor
    -- Declaracion de variables
    variable numTry0 : unsigned(3 downto 0) := (others => '0');
    variable numTry1 : unsigned(3 downto 0) := (others => '0');
    variable numTry2 : unsigned(3 downto 0) := (others => '0');
    variable numTry3 : unsigned(3 downto 0) := (others => '0');
    variable numTry4 : unsigned(3 downto 0) := (others => '0');
    variable numTry5 : unsigned(3 downto 0) := (others => '0');
    variable numTry6 : unsigned(3 downto 0) := (others => '0');
    variable numTry7 : unsigned(3 downto 0) := (others => '0');
    begin
        if RST = '1' then
            numTry0 := (others => '0');
            numTry1 := (others => '0');
            numTry2 := (others => '0');
            numTry3 := (others => '0');
            numTry4 := (others => '0');
            numTry5 := (others => '0');
            numTry6 := (others => '0');
            numTry7 := (others => '0');
        elsif CLK'event and CLK = '1' then
            if GUESSER_NUMBER_OK = '1' then
                if(numTry0 < 9) then
                    numTry0 := numTry0 + 1;
                elsif(numTry1 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := numTry1 + 1;
                elsif(numTry2 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := numTry2 + 1;
                elsif(numTry3 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := numTry3 + 1;
                elsif(numTry4 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := (others => '0');
                    numTry4 := numTry4 + 1;
                elsif(numTry5 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := (others => '0');
                    numTry4 := (others => '0');
                    numTry5 := numTry5 + 1;
                elsif(numTry6 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := (others => '0');
                    numTry4 := (others => '0');
                    numTry5 := (others => '0');
                    numTry6 := numTry6 + 1;
                elsif(numTry7 < 9) then
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := (others => '0');
                    numTry4 := (others => '0');
                    numTry5 := (others => '0');
                    numTry6 := (others => '0');
                    numTry7 := numTry7 + 1;
                else
                    numTry0 := (others => '0');
                    numTry1 := (others => '0');
                    numTry2 := (others => '0');
                    numTry3 := (others => '0');
                    numTry4 := (others => '0');
                    numTry5 := (others => '0');
                    numTry6 := (others => '0');
                    numTry7 := (others => '0');
                end if;
            end if;
        end if;
        num_attempts <= std_logic_vector(numTry7) & std_logic_vector(numTry6) & std_logic_vector(numTry5) & std_logic_vector(numTry4) & std_logic_vector(numTry3) & std_logic_vector(numTry2) & std_logic_vector(numTry1) & std_logic_vector(numTry0);
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

    process(CLK, RST, PROut)
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
        CntDisplayOut <= std_logic_vector(cuenta);
    end process;

    process(CntDisplayOut) -- Proceso que modela el Decodificador de 3 bits a 8 (AND_70)
    begin
        case CntDisplayOut is
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
            AND_70 <= "11111111";
        elsif CLK'event and CLK = '1' then
            AND_70 <= Dec3To8Out;
        end if;
    end process;

    process(num_attempts, CntDisplayOut)
    -- Declaracion de variables
    begin
        case CntDisplayOut is
            when "000" => MuxDisplayOut <= num_attempts(3 downto 0);
            when "001" => MuxDisplayOut <= num_attempts(7 downto 4);
            when "010" => MuxDisplayOut <= num_attempts(11 downto 8);
            when "011" => MuxDisplayOut <= num_attempts(15 downto 12);
            when "100" => MuxDisplayOut <= num_attempts(19 downto 16);
            when "101" => MuxDisplayOut <= num_attempts(23 downto 20);
            when "110" => MuxDisplayOut <= num_attempts(27 downto 24);
            when "111" => MuxDisplayOut <= num_attempts(31 downto 28);
            when others => MuxDisplayOut <= "1111";
        end case;
    end process;

    process(MuxDisplayOut) -- Decodificador 4 bit - 7seg
    begin
        case(MuxDisplayOut) is -- gfedcba
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

    process(Dec4To7Seg, CLK, RST) -- Proceso que modela el Registro de salida de SEG_AG
    begin
        if RST = '1' then
            SEG_AG <= (others => '0');
        elsif CLK'event and CLK = '1' then
            SEG_AG <= Dec4To7Seg;
        end if;
    end process; 

end rtl;