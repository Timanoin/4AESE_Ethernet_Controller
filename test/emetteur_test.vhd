
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity emetteur_test is
end emetteur_test;

architecture behavioral of emetteur_test is
component emetteur
   port (TABORTP, TAVAILP, TFINISHP, TLASTP, CLK, RESET : in std_logic;
          TDATAI  : in std_logic_vector(7 downto 0);
          TSTARTP, TREADDP, TDONEP, TRNSMTP  : out std_logic;
          TDATAO : out std_logic_vector(7 downto 0));
end component; 
signal TABORTP_s, TAVAILP_s, TFINISHP_s, TLASTP_s, CLK_s, RESET_s : in std_logic :='0';
signal TDATAI_s  : in std_logic_vector(7 downto 0) :="00000000" ;
signal TSTARTP_s, TREADDP_s, TDONEP_s, TRNSMTP_s  : out std_logic :='0' ;
signal TDATAO_s : out std_logic_vector(7 downto 0);

constant t : time := 10 ns;
begin
    
    Clock_process : process
    begin 
    CLK_s <= not(CLK_s);
    wait for t/2;
    end process;
     
    uut : emetteur port map(
        CLK => CLK_s,
        TABORTP => TABORTP_s,
        TAVAILP => TAVAILP_s,
        TFINISHP => TFINISHP_s,
        TLASTP => TLASTP_s,
        RESET => RESET_s,
        TDATAI => TDATAI_s,
        TSTARTP => TSTARTP_s,
        TREADDP=>TREADDP_s,
        TDONEP => TDONEP_s,
        TRNSMTP => TRNSMTP_s,
        TDATAO => TADATO_s;    
    );
    
    stim_proc : process
    begin 
    TAVAILP_s <= '0', '1' after 10 ns, '0' after 20 ns;
    TLASTP_s <= '0', '1' after 1 ns;
    
end;