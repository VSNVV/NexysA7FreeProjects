library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_controller is
    port(
        RST: in std_logic;
        CLK : in std_logic;
        DATA_RX : in std_logic_vector(7 downto 0);
        DATA_RX_OK : in std_logic;
        RED_OUT : out integer range 0 to 255;
        GREEN_OUT : out integer range 0 to 255;
        BLUE_OUT : out integer range 0 to 255
    );
end rgb_controller;

architecture rtl of rgb_controller is
-- Declaracion de Sennales
type FSM is (RedIn, GreenIn, BlueIn, Outputing, Idle); -- Estados de la Maquina de Estados
signal ActualState : FSM; -- Estado actual de la Maquina de Estados
signal DataRxReg : std_logic_vector(7 downto 0); -- Sennal del Registro de Desplazamiento
signal CntData : unsigned (1 downto 0); -- Sennal del Contador de Digitos recibidos
signal ComparatorOut : std_logic; -- Sennal de salida del Comparador

begin

    RegisterDataRx: process(RST, CLK, DATA_RX, DATA_RX_OK)
    begin
        if RST = '1' then
            DataRxReg <= (others => '0');
        elsif rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                DataRxReg <= DATA_RX;
            end if;
        end if;
    end process RegisterDataRx;


    Counter: process(RST, CLK, DATA_RX_OK)
    begin
        if RST = '1' then
            CntData <= (others => '0'); 
        elsif rising_edge(CLK) then
            if DATA_RX_OK = '1' then
                if CntData = "11" then
                    CntData <= (others => '0');
                else
                    CntData <= CntData + 1;
                end if;
            end if;
        end if;
    end process Counter;

    Comparator: process(CntData)
    begin
        if CntData = "11" then
            ComparatorOut <= '1';
        else
            ComparatorOut <= '0';
        end if;
    end process Comparator;
    
    FiniteStateMachine: process(RST, CLK, DATA_RX_OK, DataRxReg, CntData, ComparatorOut, ActualState)
    begin
        if RST = '1' then
            ActualState <= RedIn;
        elsif rising_edge(CLK) then
            ActualState <= RedIn; -- Por defecto, nuestro estado sera la introducción del numero R
            case ActualState is
                when RedIn =>
                    if DATA_RX_OK = '1' then
                        if ComparatorOut = '0' then
                            ActualState <= RedIn; -- Quedan digitos por meter
                        elsif ComparatorOut = '1' then
                            ActualState <= GreenIn; -- Todos los numeros del Rojo estan metidos
                        elsif DataRxReg = x"0D" then
                            ActualState <= GreenIn; -- Se ha introducido un enter, por tanto, enviamos lo que tenemos y pasamos al siguiente
                        end if;
                    end if;
                when GreenIn =>
                    if DATA_RX_OK = '1' then
                        if ComparatorOut = '0' then
                            ActualState <= GreenIn; -- Quedan digitos por meter
                        elsif ComparatorOut = '1' then
                            ActualState <= BlueIn; -- Todos los numeros del Rojo estan metidos
                        elsif DataRxReg = x"0D" then
                            ActualState <= BlueIn; -- Se ha introducido un enter, por tanto, enviamos lo que tenemos y pasamos al siguiente
                        end if;
                    end if;
                when BlueIn =>
                    if DATA_RX_OK = '1' then
                        if ComparatorOut = '0' then
                            ActualState <= BlueIn; -- Quedan digitos por meter
                        elsif ComparatorOut = '1' then
                            ActualState <= Outputing; -- Todos los numeros del Azul estan metidos
                        elsif DataRxReg = x"0D" then
                            ActualState <= Outputing; -- Se ha introducido un enter, por tanto, enviamos lo que tenemos y pasamos al siguiente
                        end if;
                    end if;
                when Outputing =>
                    ActualState <= Idle;
                when Idle =>
                    ActualState <= Idle;
                when others =>
                    ActualState <= RedIn;
            end case;
        end if;
    end process FiniteStateMachine;
                    
                        




end rtl;