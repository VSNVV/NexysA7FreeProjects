library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_bcd_converter is
    port(CLK        : in  std_logic;
         BIN_NUM    : in std_logic_vector(26 downto 0);
         BIN_NUM_OK : in std_logic;
         BCD_OUT    : out std_logic_vector(31 downto 0));
end bin_bcd_converter;

architecture rtl of bin_bcd_converter is
-- Declaracion de Sennales
type FSM is (Idle, Converting, Outputing); -- Estados de la FSM
signal STD_Act : FSM; -- Estado actual de la FSM
signal CntEnd : std_logic; -- Fin de cuenta del Contador
signal CntPulse : std_logic; -- Pulso del contador
signal CntEnable : std_logic; -- CE del Contador
signal RegEnable : std_logic; -- Sennal de la FSM para activar el registro de salida
signal ConverterOut : std_logic_vector(31 downto 0); -- Sennal de salida de convertidor BCD
signal Clear : std_logic; -- Sennal que reinicia todo el sistema una vez enviada la conversion


begin

    process(CLK, CntEnd, BIN_NUM_OK, CntEnd, Clear, STD_Act) -- Proceso que modela la FSM
    begin
        if CLK'event and CLK = '1' then
            STD_Act <= Idle; -- Por defecto, estaremos esperando un numero
            case STD_Act is
                when Idle =>
                    Clear <= '1';
                    CntEnable <= '0';
                    RegEnable <= '0';
                    if BIN_NUM_OK = '1' then
                        STD_Act <= Converting;
                    end if;
                when Converting =>
                    Clear <= '0';
                    CntEnable <= '1';
                    if CntEnd <= '1' then
                        STD_Act <= Outputing;
                    end if;
                when Outputing =>
                    RegEnable <= '1';
                    if BIN_NUM_OK = '0' then
                        STD_Act <= Idle;
                    end if;
            end case;
        end if;
    end process;

    process(CLK, CntEnable, Clear)
    variable aux : unsigned(26 downto 0);
    variable count : unsigned(26 downto 0) := (others => '0');
    begin
        aux := unsigned(BIN_NUM);
        if Clear = '1' then
            count := (others => '0');
            CntPulse <= '0';
            CntEnd <= '0';
        elsif CLK'event and CLK = '1' then
            if CntEnable = '1' then
                if count < aux then
                    count := count + 1;
                    CntPulse <= '1';
                else
                    CntEnd <= '1';
                end if;
            end if;
        end if;
    end process;

    CntPulse <= '0' when CntPulse = '1';

    process(CLK, CntPulse)
    variable digit_0, digit_1, digit_2, digit_3, digit_4, digit_5, digit_6, digit_7 : unsigned(3 downto 0) := (others => '0');
    begin
        if Clear = '1' then
            digit_0 := (others => '0');
            digit_1 := (others => '0');
            digit_2 := (others => '0');
            digit_3 := (others => '0');
            digit_4 := (others => '0');
            digit_5 := (others => '0');
            digit_6 := (others => '0');
            digit_7 := (others => '0');
        elsif CLK'event and CLK = '1' then
            if CntPulse = '1' then
                if digit_0 = 9



                


