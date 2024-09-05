library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity receiver is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    rx          : in  std_logic;
    dato_rx     : out std_logic_vector(7 downto 0);
    error_recep : out std_logic;
    DATO_RX_OK  : out std_logic);
end receiver;

architecture rtl of receiver is
-- Declaracion de las Sennales y Constantes
constant tiempoMuestreo : integer := 29; -- Constante del prescaler, 4.34us --> 4340ns --> 4340 / 15 = 289.33 --> 289.33 / 10 = 28.93 --> 29 CLK
constant numeroMuestras : integer := 15; -- Constante del numero de muestras que se hacen para cada bit
constant numeroBits : integer := 11; -- Constante del numero de bits que se reciven
signal PR_Cnt : unsigned(4 downto 0); -- Sennal del contador del Prescaler
signal PR_FC : std_logic; -- Sennal de salida del Prescaler
signal CntM_Cnt : unsigned(3 downto 0); -- Sennal de salida del Contador que cuenta las MUESTRAS realizadas sobre un bit
signal CntM_FC : std_logic;
signal CntB_Cnt : unsigned(3 downto 0); -- Sennal de salida del COntador que cuenta los BITS leidos
signal CntB_FC : std_logic;
signal RDM_Out : std_logic_vector(14 downto 0); -- Sennal de salida del Registro de Desplazamiento que sobremuestrea RX
signal RDB_Out : std_logic_vector(10 downto 0); -- Sennal de salida del Registro de Desplazamiento que contiene los bits finales
signal CntBin : std_logic; -- Sennal de salida del Circuito Combinacional que cuenta el numero de 1 y 0 de las muestras de RX
signal Val_Out : std_logic; -- Sennal de salida del bloque combinacional que comprueba si un dato es correcto o no
type FSM is (Idle, Receiving, Outputing, Verifying, Error); --declaracion de la maquina de estados con los distintos casos posibles
signal STD_Act: FSM; --estado actual de la maquina de estados

begin
  
  process(STD_Act, CLK, RST) -- Proceso que modela el Prescaler
  begin
    if RST = '1' then
        PR_Cnt <= (others => '0');
        PR_FC <= '0';
    elsif CLK'event and CLK = '1' then
        if STD_Act = Idle then 
            PR_Cnt <= (others => '0');
            PR_FC <= '0';       
        elsif STD_Act = Receiving then
             if PR_Cnt = tiempoMuestreo - 1 then
                PR_Cnt <= (others=>'0');
                PR_FC <= '1';
             else
                PR_Cnt <= PR_Cnt + 1;
                PR_FC <= '0';
             end if;
        end if;
    end if;
  end process;
  
  process(STD_Act, PR_FC, CLK, RST)
  begin
    if RST = '1' then
        CntM_Cnt <= (others => '0');
        CntM_FC <= '0';
    elsif CLK'event and CLK = '1' then
        if STD_Act = Idle then
            CntM_Cnt <= (others => '0');
            CntM_FC <= '0';
        elsif STD_Act = Receiving then
            if PR_FC = '1'then
                if CntM_Cnt >= numeroMuestras - 1 then
                    CntM_Cnt <= (others => '0');
                    CntM_FC <= '1';
                else
                    CntM_Cnt <= CntM_Cnt + 1;
                end if;
             else 
                CntM_FC <= '0';   
            end if;
        end if;
    end if;
  end process;

  process(STD_Act, CntM_FC, CLK, RST)
  begin
      if RST = '1' then
          CntB_Cnt <= (others => '0');
          CntB_FC <= '0';
      elsif CLK'event and CLK = '1' then
          if STD_Act = Idle then
              CntB_Cnt <= (others => '0');
              CntB_FC <= '0';
          elsif STD_Act = Receiving then
              if CntM_FC = '1' then
                  if CntB_Cnt >= numeroBits - 1 then
                      CntB_Cnt <= (others => '0');
                      CntB_FC <= '1';
                  else
                      CntB_Cnt <= CntB_Cnt + 1;
                  end if;
              else 
                CntB_FC <= '0';
              end if;
          end if;
      end if;
  end process;
   
  
  process(RX, PR_FC, CLK, RST) -- Proceso que modela el Registro de Desplazamiento encargado del sobremuestreo de RX
  begin
    if RST = '1' then
      RDM_Out <= (others => '0');
    elsif (CLK'event and CLK = '1') and (PR_FC ='1') then
      -- Cada ciclo de reloj cogemos una muestra de RX, y como empezamos con el bit de menor peso, desplazamos de der a izq
      RDM_Out <= RX & RDM_Out(14 downto 1);
    end if;
  end process;

  process(RDM_Out) -- Proceso que modela el circuito combinacional que cuenta 1 y 0
  variable num0 : integer := 0; -- Variable que almacena el numero de 0
  variable num1 : integer := 0; -- Variable que almacena el numero de 1
  begin
  num0 := 0;
  num1 := 0;
    -- Contamos el numero de 1 y 0 que hay
    for i in RDM_Out'range loop
      if RDM_Out(i) = '1' then
        num1 := num1 + 1;
      else
        num0 := num0 + 1;
      end if;
    end loop;
    --Una vez que hemos terminado de contar, tenemos que asignar una salida la salida correspondiente
    if(num0 > num1) then
      -- Verificamos que hay mas 0 que 1, por tanto la salida sera un 0
      CntBin <= '0';
    else
      -- Verificamos que hay mas 1 que 0, por tanto la salida sera un 1
      CntBin <= '1';
    end if;
  end process;

  process(STD_Act, CntBin, CLK, RST) -- Proceso que modela el Registro de Desplazamiento a la salida del contador de 0 y 1
  begin
  if RST = '1' then
    RDB_Out <= (others => '0');
    elsif CLK'event and CLK = '1' then
        if STD_Act = Idle then
            RDB_Out <= (others=>'0'); 
        elsif STD_Act = Receiving then
            if CntM_FC = '1' then
            RDB_Out <= CntBin & RDB_Out(10 downto 1);
            end if;
        end if;
    end if;
  end process;

  process(RDB_Out) -- Proceso que modela el circuito combinacional que valida si un dato es correcto o no
    variable aux_par: std_logic;
    begin
    aux_par := '1';
    for i in 8 downto 1 loop
      if RDB_Out(i) = '1' then
          aux_par := not aux_par;
      end if; 
    end loop;
    
    if aux_par=RDB_Out(9) and RDB_Out(0) = '0' and RDB_Out(10) = '1' then
      Val_Out <= '1';
    else 
      Val_Out <= '0';
    end if;
  end process;
    
  process(STD_Act, RDB_Out, CLK, RST)
  begin
    if RST = '1' then
        dato_rx <= (others=> '0');
        dato_rx_ok <= '0';
    elsif CLK'event and CLK = '1' then
        if STD_Act = Idle then
           dato_rx_ok <='0';
        elsif STD_Act = Outputing then
            dato_rx_ok <= '1';
            dato_rx <= RDB_Out(8 downto 1);
        end if;
    end if;
  end process;
    
  process(rx, CntB_FC, Val_Out, STD_Act, CLK, RST)-- Proceso que modela la Maquina Finita de Estados, cuyos estados son: Idle, Receiving, Outputing, Verifying y Error
  begin 
    if RST = '1' then 
      STD_Act <= Idle;
    elsif CLK'event and CLK = '1' then
      case STD_Act is
        when Idle =>
        error_recep <= '0';
          if RX = '0' then
            STD_Act <= Receiving;
          end if;
        when Receiving =>
          if CntB_FC = '1' then
            STD_Act <= Verifying;
          end if;
        when Verifying =>
          if Val_Out = '1' then
            STD_Act <= Outputing;
          else
            error_recep <= '1';
            STD_Act <= Error;
          end if;
        when Outputing =>
          if RX = '1' then
            STD_Act <= Idle;
          end if;
        when Error =>
          if Val_Out = '0' then
            STD_Act <= Idle;        
          end if;        
      end case;   
    end if;
  end process;

end rtl;