
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity emetteur_test is
end emetteur_test;

architecture behavioral of emetteur_test is
component emetteur
   port (CLK     : in std_logic; 
        RESETN  : in std_logic;
        RENABP  : in std_logic; 
        RDATAI  : in std_logic_vector(7 downto 0);
        RBYTEP  : out std_logic;
        RCLEANP : out std_logic; 
        RCNVGP  : out std_logic; 
        RDONEP  : out std_logic;   
        RSMATIP : out std_logic; 
        RSTARTP : out std_logic;
        RDATAO  : out std_logic_vector(7 downto 0));
end component; 
signal CLK_s     : std_logic := '0';
signal RESETN_s  : std_logic := '0';
signal RENABP_s  : in std_logic; 
signal RDATAI_s  : in std_logic_vector(7 downto 0);
signal RBYTEP_s  : out std_logic;
signal RCLEANP_s : out std_logic; 
signal RCNVGP_s  : out std_logic; 
signal RDONEP_s  : out std_logic;   
signal RSMATIP_s : out std_logic; 
signal RSTARTP_s : out std_logic;
signal RDATAO_s  : out std_logic_vector(7 downto 0));
-- Clock period
constant t : time := 10 ns;
begin
    uut : emetteur port map(
        CLK => CLK_s,
        RESETN => RESETN_s,
        RENABP => RENABP_s,
        RDATAI => RDATAI_s,
        RBYTEP => RBYTEP_s,
        RCLEANP => RCLEANP_s,
        RCNVGP => RCNVGP_s,
        RDONEP => RDONEP_s,
        RSMATIP => RSMATIP_s,
        RSTARTP => RSTARTP_s,
        RDATAO => RDATAO_s;     
    );

    -- Création d'une clock de période t
    clk_proc : process
    begin 
        CLK_s <= not(CLK_s);
        wait for t/2;
    end process;
    
    -- Signaux de test
    
        RESETN_s <= '0', '1' after 100 ns;
  
    
end;