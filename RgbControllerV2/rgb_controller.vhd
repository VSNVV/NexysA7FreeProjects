library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_controller is
    port(
        RST: in std_logic;
        CLK : in std_logic;
        DATA_RX : in std_logic_vector(7 downto 0);
        DATA_RX_OK : in std_logic;
        ENTER : in std_logic;
        R : out std_logic_vector(7 downto 0);
        G : out std_logic_vector(7 downto 0);
        B : out std_logic_vector(7 downto 0)
    );
end rgb_controller;

architecture rtl of rgb_controller is
-- Declaracion de Sennales
signal counter_data_ok, counter_data : std_logic_vector(1 downto 0); -- Sennal de salida del Contador de numeros recibidos
signal shifter_in : std_logic_vector(23 downto 0); -- Sennal del Registro de Desplazamiento de entrada
signal ascii_decoder : std_logic_vector(7 downto 0); -- Sennal de salida del Decodificador ASCII

begin
    CounterDataOk: process(RST, CLK, DATA_RX_OK)
    variable count_data_ok : unsigned(1 downto 0) := (others => '0');
    begin
        if RST = '1' then
            count_data_ok := (others => '0');
            counter_data_ok <= "00";
        elsif rising_edge(CLK) then
            if count_data_ok < 3 then
                if DATA_RX_OK = '1' then
                    count_data_ok := count_data_ok + 1;
                end if;
            else
                count_data_ok := (others => '0');
            end if;
            counter_data_ok <= std_logic_vector(count_data_ok);
        end if;
    end process CounterDataOk;

    ShifterIn: process(RST, CLK, DATA_RX_OK, DATA_RX, counter_data_ok)
    variable aux : std_logic_vector(23 downto 0);
    begin
        if RST = '1' then
            shifter_in <= (others => '0');
        elsif rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                aux := aux(15 downto 0) & DATA_RX;
            end if;
            if counter_data_ok = "11" then
                shifter_in <= aux;
            end if;
        end if;
    end process ShifterIn;

    AsciiDecoder: process(shifter_in)
    variable digit1, digit2, digit3 : integer := 0;
    variable result : integer := 0;
    begin
        if (shifter_in(23 downto 16) >= x"30") and (shifter_in(23 downto 16) <= x"39") then
            digit1 := to_integer(unsigned(shifter_in(23 downto 16))) - 48;
        else
            digit1 := 0;
        end if;
    
        if (shifter_in(15 downto 8) >= x"30") and (shifter_in(15 downto 8) <= x"39") then
            digit2 := to_integer(unsigned(shifter_in(15 downto 8))) - 48;
        else
            digit2 := 0;
        end if;
    
        if (shifter_in(7 downto 0) >= x"30") and (shifter_in(7 downto 0) <= x"39") then
            digit3 := to_integer(unsigned(shifter_in(7 downto 0))) - 48;
        else
            digit3 := 0;
        end if;

        result := (digit1 * 100) + (digit2 * 10) + (digit3);

        ascii_decoder <= std_logic_vector(to_unsigned(result, 8));
    end process AsciiDecoder;

    CounterData: process(RST, CLK, ENTER)
    variable aux : unsigned(1 downto 0);
    begin
        if RST = '1' then
            counter_data <= (others => '0');
        elsif rising_edge(CLK) then
            if aux < 3 then
                if ENTER = '1' then
                    aux := aux + 1;
                end if;
            else
                aux := (others => '0');
            end if;
            counter_data <= std_logic_vector(aux);
        end if;
    end process CounterData;

    ShifterOut: process(RST, CLK, ascii_decoder, counter_data)
    variable aux : std_logic_vector(23 downto 0) := (others => '0');
    begin
        if RST = '1' then
            aux := (others => '0');
            R <= (others => '0');
            G <= (others => '0');
            B <= (others => '0');
        elsif rising_edge(CLK) then
            if ENTER = '1' then
                aux := aux(15 downto 0) & ascii_decoder;
            end if;
            if counter_data = "11" then
                R <= aux(23 downto 16);
                G <= aux(15 downto 8);
                B <= aux(7 downto 0);
            end if;
        end if;
    end process ShifterOut;

end rtl;