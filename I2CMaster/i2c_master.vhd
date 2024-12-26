library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_master is
    port(
        RST : in std_logic;
        CLK : in std_logic;
        SDA : inout std_logic;
        SCL : out std_logic;
        ACK_STATE : out std_logic;
        DATA : out std_logic_vector(7 downto 0)
    );
end i2c_master;

architecture rtl of i2c_master is
-- Declaracion de Sennales y/o Constantes
constant slave_addr : std_logic_vector(7 downto 0) := "10010111";
--constant clk_div : integer := 500; -- Para simulacion
constant clk_div : integer := 5000; -- Para implementacion
type FSM is (Idle, Start, SendSlaveAddr7, SendSlaveAddr6, SendSlaveAddr5, SendSlaveAddr4, SendSlaveAddr3, SendSlaveAddr2, SendSlaveAddr1, SendSlaveAddr0,
            ReadAck, ReadMsb7, ReadMsb6, ReadMsb5, ReadMsb4, ReadMsb3, ReadMsb2, ReadMsb1, ReadMsb0, Nack, Ending);
signal state : FSM;

signal sda_direction : std_logic;
signal scl_reg : std_logic;
signal read_sda : std_logic;
signal write_sda : std_logic;

signal prescaler_count : integer range 0 to clk_div - 1;
signal prescaler_out : std_logic;

signal temp_data : std_logic_vector(7 downto 0);

begin
    FiniteStateMachine: process(RST, CLK)
    begin
        if RST = '1' then
            state <= Idle;
        elsif rising_edge(CLK) then
            if state = Idle then
                if prescaler_out = '1' then
                    state <= Start;
                else
                    state <= Idle;
                end if;
            elsif state = Start then
                state <= SendSlaveAddr7;
            elsif state = SendSlaveAddr7 then
                state <= SendSlaveAddr6;
            elsif state = SendSlaveAddr6 then
                state <= SendSlaveAddr5;
            elsif state = SendSlaveAddr5 then
                state <= SendSlaveAddr4;
            elsif state = SendSlaveAddr4 then
                state <= SendSlaveAddr3;
            elsif state = SendSlaveAddr3 then
                state <= SendSlaveAddr2;
            elsif state = SendSlaveAddr2 then
                state <= SendSlaveAddr1;
            elsif state = SendSlaveAddr1 then
                state <= SendSlaveAddr0;
            elsif state = SendSlaveAddr0 then
                state <= ReadAck;
            elsif state = ReadAck then
                if read_sda = '0' then
                    state <= ReadMsb7;
                else
                    state <= ReadAck;
                end if;
            elsif state = ReadMsb7 then
                state <= ReadMsb6;
            elsif state = ReadMsb6 then
                state <= ReadMsb5;
            elsif state = ReadMsb5 then
                state <= ReadMsb4;
            elsif state = ReadMsb4 then
                state <= ReadMsb3;
            elsif state = ReadMsb3 then
                state <= ReadMsb2;
            elsif state = ReadMsb2 then
                state <= ReadMsb1;
            elsif state = ReadMsb1 then
                state <= ReadMsb0;
            elsif state = ReadMsb0 then
                state <= Nack;
            elsif state = Nack then
                state <= Ending;
            elsif state = Ending then
                state <= Idle;
            else
                state <= Idle;
            end if;
        end if;
    end process FiniteStateMachine;

    PrescalerStart: process(RST, CLK)
    begin
        if RST = '1' then
            prescaler_out <= '0';
            prescaler_count <= 0;
        elsif rising_edge(CLK) then
            if prescaler_count = clk_div - 1 then
                prescaler_count <= 0;
                prescaler_out <= '1';
            else
                prescaler_count <= prescaler_count + 1;
                prescaler_out <= '0';
            end if;
        end if;
    end process PrescalerStart;

    SclManager: process(RST, CLK, state)
    begin
        if RST = '1' then
            SCL <= '1';
        elsif (state = Idle) or (state = Ending) then
            SCL <= '1';
        elsif state = Start then
            SCL <= '0'; -- Cambia SCL a bajo inmediatamente después de Start
        elsif state = SendSlaveAddr7 or 
                state = SendSlaveAddr6 or 
                state = SendSlaveAddr5 or 
                state = SendSlaveAddr4 or 
                state = SendSlaveAddr3 or 
                state = SendSlaveAddr2 or 
                state = SendSlaveAddr1 or 
                state = SendSlaveAddr0 or 
                state = ReadAck or 
                state = ReadMsb7 or 
                state = ReadMsb6 or 
                state = ReadMsb5 or 
                state = ReadMsb4 or 
                state = ReadMsb3 or 
                state = ReadMsb2 or 
                state = ReadMsb1 or 
                state = ReadMsb0 or 
                state = Nack then
            SCL <= CLK; -- Alterna en otros estados
        end if;
    end process SclManager;

    SdaManager: process(state)
    begin
        case state is
            when Idle =>
                write_sda <= '1';
                sda_direction <= '1'; -- Tenemos el control de SDA
            when Start =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= '0';
            when SendSlaveAddr7 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(7);
            when SendSlaveAddr6 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(6);
            when SendSlaveAddr5 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(5);
            when SendSlaveAddr4 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(4);
            when SendSlaveAddr3 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(3);
            when SendSlaveAddr2 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(2);
            when SendSlaveAddr1 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(1);
            when SendSlaveAddr0 =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= slave_addr(0);
            when ReadAck =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb7 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb6 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb5 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb4 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb3 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb2 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb1 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when ReadMsb0 =>
                sda_direction <= '0'; -- No tenemos el control de SDA
            when Nack =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= '1';
            when Ending =>
                sda_direction <= '1'; -- Tenemos el control de SDA
                write_sda <= '1';
            when others =>
                sda_direction <= '1'; -- Por defecto, tendremos el control de SDA
                write_sda <= '1';
        end case;
    end process SdaManager;

    ShifterData: process(CLK, RST)
    begin
        if RST = '1' then
            temp_data <= (others => '0');
        elsif rising_edge(CLK) then
            if state = ReadMsb7 or state = ReadMsb6 or state = ReadMsb5 or state = ReadMsb4 or state = ReadMsb3 or state = ReadMsb2 or state = ReadMsb1 or state = ReadMsb0 then
                temp_data <= temp_data(6 downto 0) & read_sda;
            end if;
        end if;
    end process ShifterData;
    DATA <= temp_data when state = Nack or RST = '1';

    SDA <= write_sda when sda_direction = '1' else 'Z';
    read_sda <= SDA when sda_direction = '0';

    ACK_STATE <= '1' when state = ReadAck else '0';

end rtl;