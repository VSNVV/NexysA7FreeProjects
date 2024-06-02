library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_bcd_converter is
    port(CLK        : in  std_logic;
         RST        : in  std_logic;
         BIN_NUM    : in std_logic_vector(15 downto 0);
         BIN_NUM_OK : in std_logic;
         BCD_OUT    : out std_logic_vector(31 downto 0);
         BCD_OUT_OK : out std_logic);
end bin_bcd_converter;

architecture rtl of bin_bcd_converter is
-- Declaracion de Sennales
type FSM is (Idle, Converting, Outputing);
signal ActualState : FSM; -- Sennal que indica el estado actual de la FSM
signal RegNumOut : std_logic_vector(15 downto 0); -- Sennal de salida del registro de entrada
signal CntEnd : std_logic; -- Sennal de fin de cuenta del contador
signal BcdCounterOut : std_logic_vector(31 downto 0); -- Sennal de salida del cotnador BCD
begin
    BIN_NUM_Register: process(CLK, RST, BIN_NUM, BIN_NUM_OK)
    begin
        if RST = '1' then
            RegNumOut <= (others => '0');
        elsif CLK'event and CLK = '1' then
            if BIN_NUM_OK = '1' then
                RegNumOut <= BIN_NUM;
            end if;
        end if;
    end process BIN_NUM_Register;

    Counter: process(CLK, RST, RegNumOut, ActualState)
    variable CntReg : unsigned(15 downto 0) := (others => '0'); 
    variable digit_0, digit_1, digit_2, digit_3, digit_4, digit_5, digit_6, digit_7 : unsigned(3 downto 0); -- Digitos del contador BCD
    variable aux_end : std_logic;
    begin
        if RST = '1' then
            CntReg := (others => '0');
            CntEnd <= '0';
            BcdCounterOut <= (others => '0');
            digit_0 := (others => '0');
            digit_1 := (others => '0');
            digit_2 := (others => '0');
            digit_3 := (others => '0');
            digit_4 := (others => '0');
            digit_5 := (others => '0');
            digit_6 := (others => '0');
            digit_7 := (others => '0');
        elsif CLK'event and CLK = '1' then
            if ActualState = Idle then
                CntReg := (others => '0');
                aux_end := '0';
                BcdCounterOut <= (others => '0');
                digit_0 := (others => '0');
                digit_1 := (others => '0');
                digit_2 := (others => '0');
                digit_3 := (others => '0');
                digit_4 := (others => '0');
                digit_5 := (others => '0');
                digit_6 := (others => '0');
                digit_7 := (others => '0');
            elsif ActualState = Converting then
                if CntReg /= unsigned(RegNumOut) then
                    CntReg := CntReg + 1;
                    if digit_0 = "1001" then
                        digit_0 := "0000";
                        if digit_1 = "1001" then
                            digit_1 := "0000";
                            if digit_2 = "1001" then
                                digit_2 := "0000";
                                if digit_3 = "1001" then
                                    digit_3 := "0000";
                                    if digit_4 = "1001" then
                                        digit_4 := "0000";
                                        if digit_5 = "1001" then
                                            digit_5 := "0000";
                                            if digit_6 = "1001" then
                                                digit_6 := "0000";
                                                if digit_7 = "1001" then
                                                    digit_7 := "0000";
                                                else
                                                    digit_7 := digit_7 + 1;
                                                end if;
                                            else
                                                digit_6 := digit_6 + 1;
                                            end if;
                                        else
                                            digit_5 := digit_5 + 1;
                                        end if;
                                    else
                                        digit_4 := digit_4 + 1;
                                    end if;
                                else
                                    digit_3 := digit_3 + 1;
                                end if;
                            else
                                digit_2 := digit_2 + 1;
                            end if;
                        else
                            digit_1 := digit_1 + 1;
                        end if;
                    else
                        digit_0 := digit_0 + 1;
                    end if;
                end if;
            end if;
        end if;
        BcdCounterOut <= std_logic_vector(digit_7) & std_logic_vector(digit_6) & std_logic_vector(digit_5) & std_logic_vector(digit_4) & std_logic_vector(digit_3) & std_logic_vector(digit_2) & std_logic_vector(digit_1) & std_logic_vector(digit_0);
        if CntReg = unsigned(RegNumOut) then
            CntEnd <= '1';
        else
            CntEnd <= '0';
        end if;
    end process Counter;

    Out_Register: process(CLK, RST, BcdCounterOut, ActualState)
    begin
        if RST = '1' then
            BCD_OUT <= (others => '0');
            BCD_OUT_OK <= '0';
        elsif CLK'event and CLK = '1' then
            if ActualState = Outputing then
                BCD_OUT <= BcdCounterOut;
                BCD_OUT_OK <= '1';
            else
                BCD_OUT_OK <= '0';
            end if;
        end if;
    end process Out_Register;

    StateMachine: process(CLK, RST, ActualState, BIN_NUM_OK, CntEnd)
    begin
        if RST = '1' then
            ActualState <= Idle;
        elsif CLK'event and CLK = '1' then
            case ActualState is
                when Idle =>
                    if BIN_NUM_OK = '1' then
                        ActualState <= Converting;
                    else
                        ActualState <= Idle;
                    end if;
                when Converting =>
                    if CntEnd = '1' then
                        ActualState <= Outputing;
                    else
                        ActualState <= Converting;
                    end if;
                when Outputing =>
                    ActualState <= Idle;
            end case;
        end if;
    end process StateMachine;
end rtl;