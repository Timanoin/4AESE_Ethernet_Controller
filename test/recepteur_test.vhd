
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity recepteur_test is
end recepteur_test;

architecture behavioral of recepteur_test is
component recepteur
   port (CLK     : in std_logic; 
        RESETN  : in std_logic;
        RENABP  : in std_logic; 
        RDATAI  : in std_logic_vector(7 downto 0);
        RBYTEP  : out std_logic;
        RCLEANP : out std_logic; 
        RCVNGP  : out std_logic; 
        RDONEP  : out std_logic;   
        RSMATIP : out std_logic; 
        RSTARTP : out std_logic;
        RDATAO  : out std_logic_vector(7 downto 0));
end component; 
signal CLK_s     : std_logic := '0';
signal RESETN_s  : std_logic := '0';
signal RENABP_s  : std_logic; 
signal RDATAI_s  : std_logic_vector(7 downto 0);
signal RBYTEP_s  : std_logic;
signal RCLEANP_s : std_logic; 
signal RCVNGP_s  : std_logic; 
signal RDONEP_s  : std_logic;   
signal RSMATIP_s : std_logic; 
signal RSTARTP_s : std_logic;
signal RDATAO_s  : std_logic_vector(7 downto 0);
-- Clock period
constant t : time := 10 ns;
begin
    uut : recepteur port map(
        CLK => CLK_s,
        RESETN => RESETN_s,
        RENABP => RENABP_s,
        RDATAI => RDATAI_s,
        RBYTEP => RBYTEP_s,
        RCLEANP => RCLEANP_s,
        RCVNGP => RCVNGP_s,
        RDONEP => RDONEP_s,
        RSMATIP => RSMATIP_s,
        RSTARTP => RSTARTP_s,
        RDATAO => RDATAO_s     
    );

    -- Création d'une clock de période t
    clk_proc : process
    begin 
        CLK_s <= not(CLK_s);
        wait for t/2;
    end process;
    
    -- Signaux de test
    
        RESETN_s <= '0', '1' after 100 ns, '0' after 1700 ns, '1' after 2100 ns;
        RENABP_s <= '0', '1' after 110 ns, '0' after 1700 ns, '1' after 2110 ns;
        RDATAI_s <= X"00", 
        X"11" after 120 ns, --donnée inutile
        X"22" after 200 ns, --donnée inutile
        "10101011" after 280 ns, --SFD
        X"AB" after 360 ns, --NOADDR
        X"78" after 840 ns, --ADDR_SRC
        X"42" after 1320 ns, --données
        X"69" after 1400 ns, --données 
        "01010100" after 1560 ns, --EFD  
        
        X"11" after 2120 ns, --donnée inutile
        X"22" after 2200 ns, --donnée inutile
        "10101011" after 2280 ns, --SFD
        X"AB" after 2360 ns, --NOADDR
        X"32" after 2840 ns, --ADDR_SRC
        X"55" after 3320 ns, --données
        X"25" after 3400 ns, --données 
        "01010100" after 3560 ns; --EFD  
 
end;