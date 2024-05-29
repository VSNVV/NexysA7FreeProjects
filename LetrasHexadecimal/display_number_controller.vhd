library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_number_controller is
  port(RST       : in  std_logic;
      CLK        : in  std_logic; 
      NUMBER_IN  : in  std_logic_vector(7 downto 0);
      NUMBER_OK  : in  std_logic;
      SEG_AG     : out  std_logic_vector(6 downto 0);
      AND_70     : out  std_logic_vector(7 downto 0));
end display_number_controller;

architecture rtl of display_number_controller is
-- Declaracion de Sennales
constant CLKDIV : integer := 70000; -- Tasa de refresco de los Displays
signal PROut : std_logic; -- Sennal de salida del Prescaler
signal CntOut : std_logic_vector(2 downto 0); -- Sennal de salida del Contador de 0 a 7
signal Decoder3To8 : std_logic_vector(7 downto 0); -- Sennal de salida del decodificador de 3 a 8 bits
signal DecHexOut : std_logic_vector(6 downto 0);
signal RegNumberOut : std_logic_vector(31 downto 0); -- Sennal de salida del Registro de NUMBER_IN
signal MuxOut : std_logic_vector(3 downto 0); -- Sennal de salida del Multiplexor


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
        RegNumberOut <= RegNumberOut(23 downto 0) & NUMBER_IN;
      end if;
    end if;
  end process RegisterNumberIn;

  Multiplexor32BitsTo4: process(CntOut, RegNumberOut)
  begin
    case CntOut is
      when "000" =>
        MuxOut <= RegNumberOut(3 downto 0);
      when "001" =>
        MuxOut <= RegNumberOut(7 downto 4);
      when "010" =>
        MuxOut <= RegNumberOut(11 downto 8);
      when "011" =>
        MuxOut <= RegNumberOut(15 downto 12);
      when "100" =>
        MuxOut <= RegNumberOut(19 downto 16);
      when "101" =>
        MuxOut <= RegNumberOut(23 downto 20);
      when "110" =>
        MuxOut <= RegNumberOut(27 downto 24);
      when "111" =>
        MuxOut <= RegNumberOut(31 downto 28);
      when others =>
        MuxOut <= RegNumberOut(31 downto 28);
    end case;
  end process Multiplexor32BitsTo4;

  Decoder4BitsTo7Seg: process(MuxOut)
  begin
    case MuxOut is
      when x"0" =>
        DecHexOut <= "1000000";
      when x"1" =>
        DecHexOut<= "1111001";
      when x"2" =>
        DecHexOut <= "0100100"; 
      when x"3" =>
        DecHexOut <= "0110000";
      when x"4" =>
        DecHexOut <= "0011001";
      when x"5" =>
        DecHexOut <= "0010010";
      when x"6" =>
        DecHexOut <= "0000010";
      when x"7" =>
        DecHexOut <= "1111000";
      when x"8" =>
        DecHexOut <= "0000000";
      when x"9" =>
        DecHexOut <= "0011000";
      when x"A" =>
        DecHexOut <= "0001000";
      when x"B" =>
        DecHexOut <= "0000011";
      when x"C" =>
        DecHexOut <= "1000110"; 
      when x"D" =>
        DecHexOut <= "0100001";
      when x"E" =>
        DecHexOut <= "0000110";
      when x"F" =>
        DecHexOut <= "0001110";
      when others =>
        DecHexOut <= "0000000"; 
    end case;
  end process Decoder4BitsTo7Seg;

  RegisterSEG_AG: process(CLK, DecHexOut)
  begin
    if CLK'event and CLK = '1' then
      SEG_AG <= DecHexOut;
    end if;
  end process RegisterSEG_AG;

end rtl;