
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_test is
end top_test;

architecture behavioral of top_test is

    component top
    port (CLK     : in std_logic; 
        RESETN  : in std_logic;
        -- Reception
        RENABP  : in std_logic; 
        RDATAI  : in std_logic_vector(7 downto 0);
        RBYTEP  : out std_logic;
        RCLEANP : out std_logic; 
        RCVNGP  : out std_logic; 
        RDONEP  : out std_logic;   
        RSMATIP : out std_logic; 
        RSTARTP : out std_logic;
        RDATAO  : out std_logic_vector(7 downto 0);
        -- Emission
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
        -- Collisions
        TSOCOLP : out std_logic);
    end component; 

    signal CLK_s     : std_logic := '0';
    signal RESETN_s  : std_logic;
    signal RENABP_s  : std_logic; 
    signal RDATAI_s  : std_logic_vector(7 downto 0);
    signal RBYTEP_s  : std_logic;
    signal RCLEANP_s : std_logic; 
    signal RCVNGP_s  : std_logic; 
    signal RDONEP_s  : std_logic;   
    signal RSMATIP_s : std_logic; 
    signal RSTARTP_s : std_logic;
    signal RDATAO_s  : std_logic_vector(7 downto 0);
    signal TABORTP_s : std_logic;
    signal TAVAILP_s : std_logic;
    signal TFINISHP_s: std_logic;
    signal TLASTP_s  : std_logic;
    signal TDATAI_s  : std_logic_vector(7 downto 0) := (others => '0') ;
    signal TSTARTP_s : std_logic;
    signal TREADDP_s : std_logic;
    signal TDONEP_s  : std_logic;
    signal TRNSMTP_s : std_logic;
    signal TDATAO_s  : std_logic_vector(7 downto 0);
    signal TSOCOLP_s : std_logic;
    -- Clock period
    constant t : time := 10 ns;

begin
    uut : top port map(
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
        RDATAO => RDATAO_s, 
        TABORTP => TABORTP_s,
        TAVAILP => TAVAILP_s,
        TFINISHP => TFINISHP_s,
        TLASTP => TLASTP_s,
        TDATAI => TDATAI_s,
        TDATAO => TDATAO_s,
        TSTARTP => TSTARTP_s,
        TREADDP => TREADDP_s,
        TDONEP => TDONEP_s,
        TRNSMTP => TRNSMTP_s,
        TSOCOLP => TSOCOLP_s            
    );

    -- Cr??ation d'une clock de p??riode t
    clk_proc : process
    begin 
        CLK_s <= not(CLK_s);
        wait for t/2;
    end process;
    
    -- Tests ?? effectuer :
    -- * Test T1 : Transmission d'une trame sans souci
    -- * Test T2 : Transmission d'une trame avec avortement
    -- * Test R1 : R??ception d'une trame sans souci
    -- * Test R2 : R??ception d'une trame qui ne nous est pas adress??e
    -- * Test C1 : Tentative de transmission puis r??ception simultan??e => collision
    -- * Test C2 : Tentative de r??ception puis transmission simultan??e => collision
    
    RESETN_s <= '0', '1' after 100 ns,                -- T1
                '0' after 2000 ns, '1' after 2100 ns, -- T2
                '0' after 4000 ns, '1' after 4100 ns, -- R1
                '0' after 6000 ns, '1' after 6100 ns, -- R2
                '0' after 7800 ns, '1' after 7900 ns, -- C1
                '0' after 10000 ns, '1' after 10100 ns, -- C2
                '0' after 12000ns;
    -- ========= --
    -- RECEPTION -- FINI
    -- ========= --
    RENABP_s <= '0', '1' after 100 ns,                -- T1
                '0' after 2000 ns, '1' after 2100 ns, -- T2
                '0' after 4000 ns, '1' after 4100 ns, -- R1
                '0' after 6000 ns, '1' after 6100 ns, -- R2
                '0' after 7800 ns, '1' after 7900 ns, -- C1
                '0' after 10000 ns, '1' after 10100 ns, -- C2
                '0' after 12000 ns;

    RDATAI_s <= X"00",        -- T1, T2
    -- R1
    X"88" after 4120 ns,      --donn??e inutile
    X"11" after 4200 ns,      --donn??e inutile
    "10101011" after 4280 ns, --SFD
    X"AB" after 4360 ns,      --NOADDR
    X"78" after 4840 ns,      --ADDR_SRC
    X"42" after 5320 ns,      --donn??es
    X"69" after 5400 ns,      --donn??es 
    "01010100" after 5480 ns, --EFD  
    X"00" after 5560 ns,
    --R2
    X"00" after 6120 ns,      --donn??e inutile
    X"12" after 6200 ns,      --donn??e inutile
    "10101011" after 6280 ns, --SFD
    X"AC" after 6360 ns,      --NOADDR
    X"32" after 6840 ns,      --ADDR_SRC
    X"55" after 7320 ns,      --donn??es
    X"25" after 7400 ns,      --donn??es 
    X"52" after 7480 ns,      --donn??es
    "01010100" after 7560 ns, --EFD  
    X"00" after 7640 ns,
    --C1
    X"11" after 8320 ns,      --donn??e inutile
    X"22" after 8400 ns,      --donn??e inutile
    "10101011" after 8480 ns, --SFD
    X"AB" after 8560 ns,      --NOADDR
    X"32" after 9040 ns,      --ADDR_SRC
    X"01" after 9520 ns,      --donn??es
    X"02" after 9600 ns,      --donn??es 
    X"03" after 9680 ns,      --donn??es 
    X"04" after 9760 ns,      --donn??es 
    X"05" after 9840 ns,      --donn??es 
    "01010100" after 9760 ns, --EFD 
    X"00" after 9840 ns,
    --C2
    X"11" after 10120 ns,      --donn??e inutile
    X"22" after 10200 ns,      --donn??e inutile
    "10101011" after 10280 ns, --SFD
    X"AB" after 10360 ns,      --NOADDR
    X"32" after 10840 ns,      --ADDR_SRC
    X"01" after 11320 ns,      --donn??es
    X"02" after 11400 ns,      --donn??es 
    "01010100" after 11480 ns, --EFD 
    X"00" after 11560 ns;
    
    -- ======== --
    -- EMISSION --
    -- ======== --

    TAVAILP_s <= '0', 
    '1' after 110 ns, -- T1
    '0' after 120 ns,       
    '1' after 2110 ns, -- T2 
    '0' after 2120 ns,
    '1' after 8070 ns, -- C1
    '0' after 8080 ns,
    '1' after 10420 ns, -- C2
    '0' after 10430 ns;

    TABORTP_s <= '0', 
    '1' after 2560 ns, -- T2
    '0' after 2570 ns;

    TFINISHP_s <= 'Z';

    TDATAI_s <= X"00", 
    -- T1
    X"CD" after 190 ns, -- Adresse destinataire 
    X"EF" after 270 ns, -- Adresse destinataire 
    X"CD" after 350 ns, -- Adresse destinataire 
    X"EF" after 430 ns, -- Adresse destinataire 
    X"CD" after 510 ns, -- Adresse destinataire 
    X"EF" after 590 ns, -- Adresse destinataire      
    X"69" after 1150 ns, -- Donn??es
    X"42" after 1230 ns, -- Donn??es
    X"00" after 1310 ns,
    -- T2
    X"CD" after 2190 ns, -- Adresse destinataire 
    X"EF" after 2270 ns, -- Adresse destinataire 
    X"CD" after 2350 ns, -- Adresse destinataire 
    X"EF" after 2430 ns, -- Adresse destinataire 
    X"CD" after 2510 ns, -- Adresse destinataire 
    X"EF" after 2590 ns, -- Adresse destinataire      
    X"01" after 3150 ns, -- Donn??es
    X"02" after 3230 ns, -- Donn??es
    X"03" after 3310 ns, -- Donn??es
    X"04" after 3390 ns, -- Donn??es
    X"00" after 3470 ns,
    -- C1
    X"CD" after 8120 ns, -- Adresse destinataire 
    X"EF" after 8200 ns, -- Adresse destinataire 
    X"CD" after 8280 ns, -- Adresse destinataire 
    X"EF" after 8360 ns, -- Adresse destinataire 
    X"CD" after 8440 ns, -- Adresse destinataire 
    X"EF" after 8520 ns, -- Adresse destinataire      
    X"69" after 8700 ns, -- Donn??es
    X"42" after 8780 ns, -- Donn??es
    X"00" after 8866 ns,
    --C2 
    X"CD" after 10500 ns, -- Adresse destinataire 
    X"EF" after 10580 ns, -- Adresse destinataire 
    X"CD" after 10660 ns, -- Adresse destinataire 
    X"EF" after 10740 ns, -- Adresse destinataire 
    X"CD" after 10820 ns, -- Adresse destinataire 
    X"EF" after 11000 ns, -- Adresse destinataire      
    X"69" after 11080 ns, -- Donn??es
    X"42" after 11160 ns, -- Donn??es
    X"00" after 11240 ns;
    
    TLASTP_s <= '0', 
    '1' after 1230 ns, '0' after 1240 ns, -- T1
    '1' after 3390 ns, '0' after 3400 ns, -- T2
    -- A MODIFIER.......
    '1' after 8780 ns, '0' after 8790 ns, -- C1
    '1' after 11160 ns, '0' after 11170 ns; -- C2
 
end;