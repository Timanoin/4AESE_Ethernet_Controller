-- Top

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top is
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
          RDATAO  : out std_logic_vector(7 downto 0);
          TABORTP  : in std_logic;
          TAVAILP  : in std_logic; 
          TFINISHP : in std_logic; 
          TLASTP   : in std_logic; 
          TDATAI   : in std_logic_vector(7 downto 0);
          TSTARTP  : out std_logic; 
          TREADDP  : out std_logic; 
          TDONEP   : out std_logic; 
          TRNSMTP  : out std_logic;
          TDATAO   : out std_logic_vector(7 downto 0);
          TSOCOLP : out std_logic);      
end top;

architecture structural of top is
    signal TSOCOLP_s : std_logic;
    signal TRNSMTP_s : std_logic;
    signal RCVNGP_s  : std_logic;

    begin 
    emetteur : entity work.emetteur(behavioral)
    port map(CLK => CLK,
        RESETN   => RESETN,
        TABORTP  => TABORTP,
        TAVAILP  => TAVAILP,
        TFINISHP => TFINISHP, 
        TLASTP   => TLASTP,
        TSOCOLP  => TSOCOLP_s,
        TDATAI   => TDATAI,
        TSTARTP  => TSTARTP,
        TREADDP  => TREADDP,
        TDONEP   => TDONEP,
        TRNSMTP  => TRNSMTP_s,
        TDATAO   => TDATAO
    );

    recepteur : entity work.recepteur(behavioral)
    port map(CLK => CLK,   
        RESETN  => RESETN,
        RENABP  => RENABP,
        RDATAI  => RDATAI,
        RBYTEP  => RBYTEP,
        RCLEANP => RCLEANP,
        RCVNGP  => RCVNGP_s,
        RDONEP  => RDONEP,
        RSMATIP => RSMATIP,
        RSTARTP => RSTARTP,
        RDATAO  => RDATAO
        );

    collisions : entity work.collisions(behavioral)
    port map(CLK => CLK,
        RESETN  => RESETN,
        TRNSMTP => TRNSMTP_s,
        RCVNGP  => RCVNGP_s,
        TSOCOLP => TSOCOLP_s
        );
    
    RCVNGP  <= RCVNGP_s;
    TRNSMTP <= TRNSMTP_s;
    TSOCOLP <= TSOCOLP_s;
end structural;