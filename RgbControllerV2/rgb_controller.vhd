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
type FSM is (Red, Green, Blue, Outputing); -- Estados de la Maquina de Estados
signal ActualState : FSM; -- Sennal que indica el estado actual de la Maquina de Estados
signal ShifterRx : std_logic_vector(23 downto 0); -- Sennal de salida del Registro de Desplazamiento
signal DecOut : std_logic_vector(7 downto 0); -- Sennal de salida del Decodificador ASCII
signal MuxRed, MuxGreen, MuxBlue : std_logic_vector(7 downto 0); -- Sennales de salida del Multiplexor

begin
    Shifter24Bits: process(RST, CLK, DATA_RX, DATA_RX_OK, ENTER)
    begin
        if (RST = '1') or (ENTER = '1') then
            ShifterRx <= (others => '0');
        elsif rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                if (DATA_RX >= x"30") and (DATA_RX <= x"39") then
                    ShifterRx <= ShifterRx(15 downto 0) & DATA_RX;
                end if;
            end if;
        end if;
    end process Shifter24Bits;
    
    DecoderASCIITo8Bit: process(ShifterRx)
    variable digit1, digit2, digit3 : integer := 0;
    variable result : integer := 0;
    begin
        digit1 := to_integer(unsigned(ShifterRX(23 downto 16))) - 48;
        digit2 := to_integer(unsigned(ShifterRX(15 downto 8))) - 48;
        digit3 := to_integer(unsigned(ShifterRX(7 downto 0))) - 48;

        result := (digit1 * 100) + (digit2 * 10) + (digit3);

        DecOut <= std_logic_vector(to_unsigned(result, 8));
    end process DecoderASCIITo8Bit;

    Multiplexor: process(ActualState, DecOut)
    begin
        if ActualState = Red then
            MuxRed <= DecOut;
        elsif ActualState = Green then
            MuxGreen <= DecOut;
        elsif ActualState = Blue then
            MuxBlue <= DecOut;
        end if;
    end process Multiplexor;

    FiniteStateMachine: process(RST, CLK, ENTER, ActualState)
    begin
        if RST = '1' then
            ActualState <= Red;
        elsif rising_edge(CLK) then
            case ActualState is
                when Red =>
                    if ENTER = '1' then
                        ActualState <= Green;
                    else
                        ActualState <= Red;
                    end if;
                when Green =>
                    if ENTER = '1' then
                        ActualState <= Blue;
                    else
                        ActualState <= Green;
                    end if;
                when Blue =>
                    if ENTER = '1' then
                        ActualState <= Outputing;
                    else
                        ActualState <= Blue;
                    end if;
                when others =>
                    ActualState <= Red;
            end case;
        end if;
    end process FiniteStateMachine;

    RegisterRGB: process(RST, CLK, ActualState, MuxRed, MuxGreen, MuxBlue)
    begin
        if RST = '1' then
            R <= (others => '0');
            G <= (others => '0');
            B <= (others => '0');
        elsif rising_edge(CLK) then
            if ActualState = Outputing then
                R <= MuxRed;
                G <= MuxGreen;
                B <= MuxBlue;
            end if;
        end if;
    end process RegisterRGB;
end rtl;