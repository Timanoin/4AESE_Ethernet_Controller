library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity impulse is
    port (CLK   : in std_logic;
          DATAI : in std_logic;
          DATAO : out std_logic);
end impulse;

architecture behavioral of impulse is
    signal DATA_s : std_logic := '0';
    signal impulse_done : std_logic := '0';
begin
    process(CLK) is
    begin
        if rising_edge(CLK) then
            if DATA_s = '0' and DATAI = '1' and impulse_done = '0' then
                DATA_s <= '1';
                impulse_done <= '1';
            else 
                DATA_s <= '0';
            end if;
            if DATAI = '0' then
                impulse_done <= '0';
            end if;         
        end if;
    end process;
    DATAO <= DATA_s;
end behavioral;