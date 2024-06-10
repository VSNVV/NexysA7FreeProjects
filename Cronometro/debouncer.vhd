library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
   generic(
      NR_OF_CLKS : integer := 4095 
   );
   port(
      CLK : in std_logic;
      sig_i : in std_logic;
      pls_o : out std_logic
   );
end debouncer;

architecture rtl of debouncer is

signal cnt : integer range 0 to NR_OF_CLKS-1;
signal sigTmp : std_logic;
signal stble, stbleTmp : std_logic;
signal pls_reg : std_logic;

begin

   DEB: process(CLK)
   begin
      if rising_edge(CLK) then
         if sig_i = sigTmp then -- Count the number of clock periods if the signal is stable
            if cnt = NR_OF_CLKS-1 then
               stble <= sig_i;
            else
               cnt <= cnt + 1;
            end if;
         else -- Reset counter and sample the new signal value
            cnt <= 0;
            sigTmp <= sig_i;
         end if;
      end if;
   end process DEB;

   PLS: process(CLK)
   begin
      if rising_edge(CLK) then
         stbleTmp <= stble;
      end if;
   end process PLS;
   
   -- generate the one-shot output signal
   pls_0 <= '1' when stbleTmp = '0' and stble = '1' else '0';

end rtl;