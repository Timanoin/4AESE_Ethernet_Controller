library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity collisions_test is
end collisions_test;

architecture behavioral of collisions_test is
component collisions
   port (TRNSMTP, RCVNGP, CLK, RESETN : in std_logic;
          TSOCOLP  : out std_logic);

end component; 
signal CLK_s     : std_logic := '0';
signal RESETN_s  : std_logic := '0';
-- input signals
signal TSOCOLP_s : std_logic := '0';
signal TRNSMTP_s : std_logic := '0';
signal RCVNGP_s : std_logic := '0';


constant t : time := 10 ns;
begin
    uut : collisions port map(
        CLK => CLK_s,
        RESETN => RESETN_s,
        TSOCOLP => TSOCOLP_s, 
        TRNSMTP => TRNSMTP_s,
        RCVNGP => RCVNGP_s
    );

    -- Création d'une clock de période t
    clk_proc : process
    begin 
        CLK_s <= not(CLK_s);
        wait for t/2;
    end process;

    -- Signaux de test

    RESETN_s <= '0', '1' after 100 ns;
    TRNSMTP_s <= '0', '1' after 150 ns;
    RCVNGP_s <= '0', '1' after 170 ns, '0' after 400 ns; 
 
   
end;    