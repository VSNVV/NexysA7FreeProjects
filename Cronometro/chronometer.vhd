library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chronometer is
  port(RST       : in  std_logic;
      CLK        : in  std_logic;
      PAUSE      : in std_logic; 
      DATA_OUT   : out std_logic_vector(31 downto 0));
end chronometer;

architecture rtl of chronometer is
-- Declaracion de constantes y sennales
constant CLK_DIV : integer := 1666667; -- Por cada estos 10 nanos (hay unos pocos ns de mas pero es inapreciable)
signal PROut : std_logic;
signal TimerOut : std_logic_vector(31 downto 0);

begin
    Prescaler: process(CLK, RST, PAUSE)
    variable count : integer := 0;
    begin
        if RST = '1' then
            count := 0;
            PROut <= '0';
        elsif rising_edge(CLK) then
            if pause = '0' then
                if count = CLK_DIV then
                    count := 0;
                    PROut <= '1';
                else
                    count := count + 1;
                    PROut <= '0';
                end if;
            else
                PROut <= '0';
            end if;
        end if;
    end process Prescaler;

    Timer: process(PROut, CLK, RST)
    variable ms_0, ms_1, s_0, s_1, m_0, m_1, h_0, h_1 : unsigned(3 downto 0) := (others => '0');
    begin
        if RST = '1' then
            ms_0 := (others => '0');
            ms_1 := (others => '0');
            s_0 := (others => '0');
            s_1 := (others => '0');
            m_0 := (others => '0');
            m_1 := (others => '0');
            h_0 := (others => '0');
            h_1 := (others => '0');
        elsif rising_edge(CLK) then
            if PROut = '1' then
                if ms_0 = "1001" then
                    ms_0 := "0000";
                    if ms_1 = "0110" then
                        ms_1 := "0000";
                        if s_0 = "1001" then
                            s_0 := "0000";
                            if s_1 = "0110" then
                                s_1 := "0000";
                                if m_0 = "1001" then
                                    m_0 := "0000";
                                    if m_1 = "0110" then
                                        m_1 := "0000";
                                        if h_0 = "1001" then
                                            h_0 := "0000";
                                            if h_1 = "0110" then
                                                h_1 := "0000";
                                            else
                                                h_1 := h_1 + 1;
                                            end if;
                                        else
                                            h_0 := h_0 + 1;
                                        end if;
                                    else
                                        m_1 := m_1 + 1;
                                    end if;
                                else
                                    m_0 := m_0 + 1;
                                end if;
                            else
                                s_1 := s_1 + 1;
                            end if;
                        else
                            s_0 := s_0 + 1;
                        end if;
                    else
                        ms_1 := ms_1 + 1;
                    end if;
                else
                    ms_0 := ms_0 + 1;
                end if;
            end if;
        end if;
    TimerOut <= std_logic_vector(h_1) & std_logic_vector(h_0) & std_logic_vector(m_1) & std_logic_vector(m_0) & std_logic_vector(s_1) & std_logic_vector(s_0) & std_logic_vector(ms_1) & std_logic_vector(ms_0);
    end process Timer;


    RegisterTimerOut: process(CLK, TimerOut)
    begin
        if rising_edge(CLK) then
            DATA_OUT <= TimerOut
        end if;
    end process RegisterTimerOut;

end rtl;