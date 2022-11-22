-- Collisions

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity collisions is
    port (CLK     : in std_logic; 
          RESETN  : in std_logic;
          RCVNGP  : in std_logic; 
          TRNSMTP : in std_logic;
          TSOCOLP : out std_logic); 
end collisions;

architecture behavioral of collisions is 
    
    -- Signaux de sortie intermédiaires
    signal TSOCOLP_s  : std_logic;  

begin 
    -- Process synchrone sur la clock de base : 
    -- gestion des impulsions, 
    -- observation du début d'émission.
    process (CLK, RESETN)
    begin
        if RESETN = '0' then
            TSOCOLP_s <= '0';
        elsif rising_edge(CLK) then
            TSOCOLP_s <= '0';
            if RCVNGP = '1' and TRNSMTP = '1' then
                TSOCOLP_s <= '1';
            end if;
        end if;
    end process;
    TSOCOLP <= TSOCOLP_s;
end behavioral; 
