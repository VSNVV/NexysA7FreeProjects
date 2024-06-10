library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
   generic(
      NR_OF_CLKS : integer := 4095 
   );
   port(
      CLK : in std_logic;
      button : in std_logic;
      signal_debounced : out std_logic
   );
end debouncer;

architecture rtl of debouncer is
-- Declaracion de Sennales y Constantes
constant cnt : integer range 0 to NR_OF_CLKS - 1;
signal PROut : std_logic;
signal cooldown : std_logic;

begin
   Prescaler: process(CLK)
   if rising_edge(CLK) then
      if cooldown = '1' then
         if cnt = NR_OF_CLKS - 1 then
            PROut <= '1';
            cnt ;



end rtl;