library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_letter_controller is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      NUMBER_IN  : in  std_logic_vector(7 downto 0);
      NUMBER_OK  : in  std_logic;
      SEG_AG     : out  std_logic_vector(6 downto 0);
      AND_70     : out  std_logic_vector(7 downto 0));
end display_letter_controller;

architecture rtl of display_letter_controller is
-- Declaracion de Sennales
constant CLKDIV : integer := 70000; -- Tasa de refresco de los Displays
signal PROut : std_logic; -- Sennal de salida del Prescaler
signal CntOut : std_logic_vector(2 downto 0); -- Sennal de salida del Contador de 0 a 7
signal Decoder3To8 : std_logic_vector(7 downto 0); -- Sennal de salida del decodificador de 3 a 8 bits
signal DecHexOut : std_logic_vector(6 downto 0);
signal RegNumberOut : std_logic_vector(63 downto 0); -- Sennal de salida del Registro de NUMBER_IN
signal MuxOut : std_logic_vector(7 downto 0); -- Sennal de salida del Multiplexor


begin
  Prescaler: process(CLK, RST)
  variable countPrescaler : integer := 0;
  begin
    if RST = '1' then
      countPrescaler := 0;
      PROut <= '0';
    elsif CLK'event and CLK = '1' then
      if countPrescaler = CLKDIV then
        countPrescaler := 0;
        PROut <= '1';
      else
        countPrescaler := countPrescaler + 1;
        PROut <= '0';
      end if;
    end if;
  end process Prescaler;

  Counter0To7: process(CLK, RST, PROut)
  variable cntReg : unsigned(2 downto 0);
  begin
    if RST = '1' then
      cntReg := (others => '0');
    elsif CLK'event and CLK = '1' then
      if PROut = '1' then
        if cntReg = 7 then
          cntReg := (others => '0');
        else
          cntReg := cntReg + 1;
        end if;
      end if;
    end if;
    CntOut <= std_logic_vector(cntReg);
  end process Counter0To7;

  Decoder3BitsTo8Bits: process(CntOut)
  begin
    case CntOut is
      when "000" => Decoder3To8 <= "11111110";
      when "001" => Decoder3To8 <= "11111101";
      when "010" => Decoder3To8 <= "11111011";
      when "011" => Decoder3To8 <= "11110111";
      when "100" => Decoder3To8 <= "11101111";
      when "101" => Decoder3To8 <= "11011111";
      when "110" => Decoder3To8 <= "10111111";
      when "111" => Decoder3To8 <= "01111111";
    end case;
  end process Decoder3BitsTo8Bits;

  RegisterAND_70: process(Decoder3To8, CLK)
  begin
    if CLK'event and CLK = '1' then
      AND_70 <= Decoder3To8;
    end if;
  end process RegisterAND_70;

  RegisterNumberIn: process(CLK, RST, NUMBER_IN, NUMBER_OK)
  begin
    if RST = '1' then
      RegNumberOut <= (others => '0');
    elsif CLK'event and CLK = '1' then
      if NUMBER_OK = '1' then
        RegNumberOut <= RegNumberOut(55 downto 0) & NUMBER_IN;
      end if;
    end if;
  end process RegisterNumberIn;

  Multiplexor32BitsTo4: process(CntOut, RegNumberOut)
  begin
    case CntOut is
      when "000" =>
        MuxOut <= RegNumberOut(7 downto 0);
      when "001" =>
        MuxOut <= RegNumberOut(15 downto 8);
      when "010" =>
        MuxOut <= RegNumberOut(23 downto 16);
      when "011" =>
        MuxOut <= RegNumberOut(31 downto 24);
      when "100" =>
        MuxOut <= RegNumberOut(39 downto 32);
      when "101" =>
        MuxOut <= RegNumberOut(47 downto 40);
      when "110" =>
        MuxOut <= RegNumberOut(55 downto 48);
      when "111" =>
        MuxOut <= RegNumberOut(63 downto 56);
      when others =>
        MuxOut <= RegNumberOut(63 downto 56);
    end case;
  end process Multiplexor32BitsTo4;

  Decoder4BitsTo7Seg: process(MuxOut)
  begin
    case MuxOut is -- gfedcba
      -- Space and punctuation
      when x"20" => DecHexOut <= "1111111"; -- Space (all DecHexOut off)
      when x"21" => DecHexOut <= "1111001"; -- !
      when x"22" => DecHexOut <= "0010100"; -- "
      when x"23" => DecHexOut <= "0110111"; -- #
      when x"24" => DecHexOut <= "0110110"; -- $
      when x"25" => DecHexOut <= "1101010"; -- %
      when x"26" => DecHexOut <= "0000000"; -- & (all DecHexOut on, example)
      when x"27" => DecHexOut <= "1010000"; -- '
      when x"28" => DecHexOut <= "1000111"; -- (
      when x"29" => DecHexOut <= "1110001"; -- )
      when x"2A" => DecHexOut <= "0111111"; -- * (not standard, example)
      when x"2B" => DecHexOut <= "1111111"; -- + (all DecHexOut off, example)
      when x"2C" => DecHexOut <= "1110011"; -- ,
      when x"2D" => DecHexOut <= "0111111"; -- - (not standard, example)
      when x"2E" => DecHexOut <= "1101111"; -- .
      when x"2F" => DecHexOut <= "1101010"; -- /

      -- Digits 0-9
      when x"30" => DecHexOut <= "1000000"; -- 0
      when x"31" => DecHexOut <= "1111001"; -- 1
      when x"32" => DecHexOut <= "0100100"; -- 2
      when x"33" => DecHexOut <= "0110000"; -- 3
      when x"34" => DecHexOut <= "0011001"; -- 4
      when x"35" => DecHexOut <= "0010010"; -- 5
      when x"36" => DecHexOut <= "0000010"; -- 6
      when x"37" => DecHexOut <= "1111000"; -- 7
      when x"38" => DecHexOut <= "0000000"; -- 8
      when x"39" => DecHexOut <= "0010000"; -- 9

      -- More punctuation
      when x"3A" => DecHexOut <= "1110110"; -- :
      when x"3B" => DecHexOut <= "1110010"; -- ;
      when x"3C" => DecHexOut <= "1000110"; -- <
      when x"3D" => DecHexOut <= "0111111"; -- = (not standard, example)
      when x"3E" => DecHexOut <= "1110000"; -- >
      when x"3F" => DecHexOut <= "1101110"; -- ?

      -- Uppercase letters A-Z
      when x"40" => DecHexOut <= "1110110"; -- @ (not standard, example)
      when x"41" => DecHexOut <= "0001000"; -- A
      when x"42" => DecHexOut <= "0000011"; -- B
      when x"43" => DecHexOut <= "1000110"; -- C
      when x"44" => DecHexOut <= "0100001"; -- D
      when x"45" => DecHexOut <= "0000110"; -- E
      when x"46" => DecHexOut <= "0001110"; -- F
      when x"47" => DecHexOut <= "0010000"; -- G
      when x"48" => DecHexOut <= "0001001"; -- H
      when x"49" => DecHexOut <= "1001111"; -- I
      when x"4A" => DecHexOut <= "1100001"; -- J
      when x"4B" => DecHexOut <= "0001111"; -- K (example, non-standard)
      when x"4C" => DecHexOut <= "1000111"; -- L
      when x"4D" => DecHexOut <= "1101010"; -- M (example, non-standard)
      when x"4E" => DecHexOut <= "1111011"; -- N (example, non-standard)
      when x"4F" => DecHexOut <= "1000000"; -- O
      when x"50" => DecHexOut <= "0001100"; -- P
      when x"51" => DecHexOut <= "0011000"; -- Q (example, non-standard)
      when x"52" => DecHexOut <= "1111111"; -- R (example, non-standard)
      when x"53" => DecHexOut <= "0010010"; -- S
      when x"54" => DecHexOut <= "0000111"; -- T (example, non-standard)
      when x"55" => DecHexOut <= "1000001"; -- U
      when x"56" => DecHexOut <= "1111111"; -- V (example, non-standard)
      when x"57" => DecHexOut <= "1111111"; -- W (example, non-standard)
      when x"58" => DecHexOut <= "1111111"; -- X (example, non-standard)
      when x"59" => DecHexOut <= "1111111"; -- Y (example, non-standard)
      when x"5A" => DecHexOut <= "0100100"; -- Z

      -- Lowercase letters a-z
      when x"61" => DecHexOut <= "0001000"; -- a (Same as A)
      when x"62" => DecHexOut <= "0000011"; -- b (Same as B)
      when x"63" => DecHexOut <= "1000110"; -- c (Same as C)
      when x"64" => DecHexOut <= "0100001"; -- d (Same as D)
      when x"65" => DecHexOut <= "0000110"; -- e (Same as E)
      when x"66" => DecHexOut <= "0001110"; -- f (Same as F)
      when x"67" => DecHexOut <= "0010000"; -- g (Same as G)
      when x"68" => DecHexOut <= "0001001"; -- h (Same as H)
      when x"69" => DecHexOut <= "1001111"; -- i (Same as I)
      when x"6A" => DecHexOut <= "1100001"; -- j (Same as J)
      when x"6B" => DecHexOut <= "0001111"; -- k (Same as K, example)
      when x"6C" => DecHexOut <= "1000111"; -- l (Same as L)
      when x"6D" => DecHexOut <= "1101010"; -- m (Same as M, example)
      when x"6E" => DecHexOut <= "0101011"; -- n (Same as N, example)
      when x"6F" => DecHexOut <= "1000000"; -- o (Same as O)
      when x"70" => DecHexOut <= "0001100"; -- p (Same as P)
      when x"71" => DecHexOut <= "0011000"; -- q (Same as Q, example)
      when x"72" => DecHexOut <= "0101111"; -- r (Same as R, example)
      when x"73" => DecHexOut <= "0010010"; -- s (Same as S)
      when x"74" => DecHexOut <= "0000111"; -- t (Same as T, example)
      when x"75" => DecHexOut <= "1000001"; -- u (Same as U)
      when x"76" => DecHexOut <= "1111111"; -- v (Same as V, example)
      when x"77" => DecHexOut <= "1111111"; -- w (Same as W, example)
      when x"78" => DecHexOut <= "1111111"; -- x (Same as X, example)
      when x"79" => DecHexOut <= "1111111"; -- y (Same as Y, example)
      when x"7A" => DecHexOut <= "0100100"; -- z (Same as Z)

      -- More punctuation and special characters
      when x"5B" => DecHexOut <= "1000110"; -- [
      when x"5C" => DecHexOut <= "1111111"; -- \ (all DecHexOut off, example)
      when x"5D" => DecHexOut <= "1100000"; -- ]
      when x"5E" => DecHexOut <= "0111111"; -- ^ (not standard, example)
      when x"5F" => DecHexOut <= "0001000"; -- _
      when x"60" => DecHexOut <= "0001111"; -- ` (not standard, example)
      when x"7B" => DecHexOut <= "0001111"; -- {
      when x"7C" => DecHexOut <= "1111111"; -- | (all DecHexOut off, example)
      when x"7D" => DecHexOut <= "0110000"; -- }
      when x"7E" => DecHexOut <= "0111111"; -- ~ (not standard, example)
      when x"7F" => DecHexOut <= "1111111"; -- DEL (all DecHexOut off)

      -- Default case for unsupported characters
      when others => DecHexOut <= "1111111"; -- All DecHexOut off
  end case;
  end process Decoder4BitsTo7Seg;

  RegisterSEG_AG: process(CLK, DecHexOut)
  begin
    if CLK'event and CLK = '1' then
      SEG_AG <= DecHexOut;
    end if;
  end process RegisterSEG_AG;

end rtl;