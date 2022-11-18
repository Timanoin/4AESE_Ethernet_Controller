
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity emetteur_test is
end emetteur_test;

architecture behavioral of emetteur_test is
component emetteur
   port (TABORTP, TAVAILP, TFINISHP, TLASTP, CLK, RESETN : in std_logic;
          TDATAI  : in std_logic_vector(7 downto 0);
          TSTARTP, TREADDP, TDONEP, TRNSMTP  : out std_logic;
          TDATAO : out std_logic_vector(7 downto 0));
end component; 
signal CLK_s     : std_logic := '0';
signal RESETN_s  : std_logic := '0';
-- input signals
signal TABORTP_s : std_logic := '0';
signal TAVAILP_s : std_logic := '0';
signal TFINISHP_s: std_logic := '0';
signal TLASTP_s  : std_logic := '0';
signal TDATAI_s  : std_logic_vector(7 downto 0) := (others => '0') ;
-- output signals
signal TSTARTP_s : std_logic :='0';
signal TREADDP_s : std_logic :='0';
signal TDONEP_s  : std_logic :='0';
signal TRNSMTP_s : std_logic :='0';
signal TDATAO_s  : std_logic_vector(7 downto 0);
-- Clock period
constant t : time := 10 ns;
begin
    uut : emetteur port map(
        CLK => CLK_s,
        RESETN => RESETN_s,
        TABORTP => TABORTP_s, 
        TAVAILP => TAVAILP_s,
        TFINISHP => TFINISHP_s,
        TLASTP => TLASTP_s,
        TDATAI => TDATAI_s,
        TSTARTP => TSTARTP_s, 
        TREADDP=>TREADDP_s,
        TDONEP => TDONEP_s,
        TRNSMTP => TRNSMTP_s,
        TDATAO => TDATAO_s    
    );

    -- Création d'une clock de période t
    clk_proc : process
    begin 
        CLK_s <= not(CLK_s);
        wait for t/2;
    end process;
    
    -- Signaux de test
    
        RESETN_s <= '0', '1' after 100 ns;
        TAVAILP_s <= '0', '1' after 110 ns, '0' after 120 ns;
        TABORTP_s <= '0', '1' after 560 ns, '0' after 570 ns;
        TFINISHP_s <= 'Z';
        TDATAI_s <= X"00", X"CD" after 190 ns, X"EF" after 270 ns, X"CD" after 350 ns, X"EF" after 430 ns, X"CD" after 510 ns, X"EF" after 590 ns, X"69" after 1150 ns, X"42" after 1230 ns;
        TLASTP_s <= '0', '1' after 1230 ns, '0' after 1240 ns ;
  
    
end;