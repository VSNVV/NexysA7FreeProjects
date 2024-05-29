library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_controller is
  port(RST        : in  std_logic;
       CLK        : in  std_logic; 
       NUMBER_IN  : in  std_logic_vector(7 downto 0);
       SEG_AG     : in  std_logic_vector(6 downto 0);
       AND_70     : in  std_logic_vector(7 downto 0));
end display_controller;

architecture rtl of display_controller is
-- Declaracion de Sennales
constant CTE_PRESCALER : integer := 200;
signal CntDisplayOut : std_logic_vector(2 downto 0);
signal Dec3To8Out : std_logic_vector(7 downto 0);

begin
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
            AND_70 <= "11111111"
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



