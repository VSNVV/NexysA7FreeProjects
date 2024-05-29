library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_puls is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      BUTTONJ1   : in  std_logic;
      BUTTONJ2   : in  std_logic;
      PULS_OUT   : out std_logic_vector(31 downto 0);
      PULS_OUT_OK : out std_logic;
      END_GAME   : out std_logic);
end count_puls;

architecture rtl of count_puls is
-- Declaracion de Sennales
signal CntButtonOut : std_logic_vector(31 downto 0);
signal puls_out_ok_reg : std_logic;
signal stop : std_logic;

begin
    process(BUTTONJ1, BUTTONJ2, CLK, RST)
    variable cnt_regJ1_0, cnt_regJ1_1, cnt_regJ2_0, cnt_regJ2_1 : unsigned(3 downto 0) := (others => '0');
    begin
        if RST = '1' then
            cnt_regJ1_0 := (others => '0');
            cnt_regJ1_1 := (others => '0');
            cnt_regJ2_0 := (others => '0');
            cnt_regJ2_1 := (others => '0');
        elsif CLK'event and CLK = '1' then
            if stop = '0' then
                if BUTTONJ1 = '1' then
                    if cnt_regJ1_1 < 3 then
                        if cnt_regJ1_0 = 9 then
                            cnt_regJ1_0 := (others => '0');
                            cnt_regJ1_1 := cnt_regJ1_1 + 1;
                        else
                            cnt_regJ1_0 := cnt_regJ1_0 + 1;
                        end if;
                    end if;
                end if;
                if BUTTONJ2 = '1' then
                    if cnt_regJ2_1 < 3 then
                        if cnt_regJ2_0 = 9 then
                            cnt_regJ2_0 := (others => '0');
                            cnt_regJ2_1 := cnt_regJ2_1 + 1;
                        else
                            cnt_regJ2_0 := cnt_regJ2_0 + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
        CntButtonOut <= std_logic_vector(cnt_regJ2_1) & std_logic_vector(cnt_regJ2_0) & "1111111111111111" & std_logic_vector(cnt_regJ1_1) & std_logic_vector(cnt_regJ1_0);
    end process;
    
    process(CntButtonOut)
    variable pulsJ2_1, pulsJ1_1 : std_logic_vector(3 downto 0);
    begin
        pulsJ2_1 := CntButtonOut(31 downto 28);
        pulsJ1_1 := CntButtonOut(7 downto 4);
        if(pulsJ1_1 = "0011" or pulsJ2_1 = "0011") then
            END_GAME <= '1';
            stop <= '1';
        else
            END_GAME <= '0';
            stop <= '0';
        end if;
    end process;

    process(CLK, CntButtonOut, puls_out_ok_reg)
    begin
        if CLK'event and CLK = '1' then
            if puls_out_ok_reg = '0' then
                PULS_OUT <= CntButtonOut;
                PULS_OUT_OK <= '1';
            else
                PULS_OUT_OK <= '0';
            end if;
        end if;
    end process;
end rtl;



                