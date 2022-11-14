-- Emetteur

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity emetteur is
    port (TABORTP  : in std_logic;
          TAVAILP  : in std_logic; 
          TFINISHP : in std_logic; 
          TLASTP   : in std_logic; 
          CLK      : in std_logic; 
          RESETN   : in std_logic;
          TDATAI   : in std_logic_vector(7 downto 0);
          TSTARTP  : out std_logic; 
          TREADDP  : out std_logic; 
          TDONEP   : out std_logic; 
          TRNSMTP  : out std_logic;
          TDATAO   : out std_logic_vector(7 downto 0));
end emetteur;

architecture behavioral of emetteur is 
    
    -- Signaux de sortie intermédiaires
    signal TRNSMTP_s : std_logic := '0'; 
    signal TSTARTP_s : std_logic := '0'; 
    signal TREADDP_s : std_logic := '0'; 
    signal TDONEP_s  : std_logic := '0';
    -- Horloges
    signal CLK8     : std_logic := '0';
    signal RST_CLK8 : std_logic := '1';
    -- Compteurs
    signal cmp_src  : integer := 0; 
    signal cmp_dest : integer := 0; 
    signal cmp_clk : std_logic_vector(7 downto 0) := "00000000"; 
    -- Signaux booleens
    signal SFD_done  : bit := '0'; 
    signal EFD_done  : bit := '0'; 
    signal src_done  : bit := '0'; 
    signal dest_done : bit := '0';
    signal DATA_done : bit := '0';     
    -- Vecteurs constants
    constant SFD : std_logic_vector(7 downto 0) := "10101011";
    constant EFD : std_logic_vector(7 downto 0) := "01010100";
    constant ADDR_SRC : std_logic_vector(47 downto 0) := X"ABABABABABAB"; 
    
begin 
    -- Process synchrone sur la clock de base : 
    -- gestion des impulsions, 
    -- observation du début d'émission.
    process (CLK)
    begin
        if RESETN = '0'
            TRNSMTP_s <= '0'; 
            TSTARTP_s <= '0'; 
            TREADDP_s <= '0'; 
            TDONEP_s  <= '0';
            RST_CLK8 <= '1';
            cmp_src  <= 0; 
            cmp_dest <= 0; 
            SFD_done  <= '0'; 
            EFD_done  <= '0'; 
            src_done  <= '0'; 
            dest_done <= '0';
            DATA_done <= '0';
        elsif rising_edge(CLK) then
            -- Début émission
            if TAVAILP = '1' and TRNSMTP_s = '0' then             
                TRNSMTP_s <= '1';
                TSTARTP_s <= '1';
                -- Activation Clock 8 bits
                RST_CLK8 <= '0';
            end if;
            -- Gestion des impulsions
            if TREADDP_s ='1' then TREADDP_s <='0'; end if;            
            if TDONEP_s  ='1' then TDONEP_s  <='0'; end if;                
            if TSTARTP_s ='1' then TSTARTP_s <='0'; end if;        
        end if;
    end process;
    
    -- Process synchrone sur la CLK8 : actif tous les 8 fronts de CLK
    process (CLK8, RESETN)
    begin
        if rising_edge(CLK8) and RESETN = '0' then
            -- Envoi du Start Frame Delimitor
            if SFD_done = '0' then
                TDATAO <= SFD;
                SFD_done <= '1';
            -- Envoi de l'adresse du destinataire
            elsif dest_done ='0' then
                TDATAO <= TDATAI;
                TREADDP_s <= '1';
                cmp_dest <= cmp_dest + 1;
                if cmp_dest = 5 then
                    dest_done <= '1'; 
                    cmp_dest <= 0;  
                end if;
            -- Envoi l'adresse de la source
            elsif src_done ='0' then
                case cmp_src is 
                    when 0 =>      TDATAO <= ADDR_SRC(47 downto 40);
                    when 1 =>      TDATAO <= ADDR_SRC(39 downto 32);
                    when 2 =>      TDATAO <= ADDR_SRC(31 downto 24);
                    when 3 =>      TDATAO <= ADDR_SRC(23 downto 16);
                    when 4 =>      TDATAO <= ADDR_SRC(15 downto 8);
                    when 5 =>      TDATAO <= ADDR_SRC(7 downto 0);
                    when others => TDATAO <= (others => '0');
                end case;
                cmp_src <= cmp_src + 1;
                if cmp_src = "101" then
                    src_done <= '1';
                    cmp_src <= "000";
                end if;
            -- Envoi des données
            elsif DATA_done = '0' then
                TDATAO <= TDATAI;
                TREADDP_s <= '1';
                if TLASTP ='1' then
                    DATA_done <= '1';
                end if;
            -- Envoi du End Frame Delimitor    
            else 
                TDATAO <= EFD;
                TDONEP_s <= '1';
                TRNSMTP_s <= '0';
                RST_CLK8 <= '1';
            end if; 
        end if;    
    end process;
    
    -- Générateur d'une clock de fréquence fCLK/8 : gestion des octets
    -- Active lorsque RST_CLK8 est à 0 (choix du moment de fonctionnement)
    CLK8_generator : process(CLK,RESETN,RESET_CLK8)
    begin 
        if RESETN = '0' or RESET_CLK8 = '1'
            CLK8 <= '0';
            cmp_clk <= "00000100";
        elsif rising_edge(CLK) then
            CLK8 <= cmp_clk(2);
            cmp_clk <= cmp_clk + 1;
        end if;
    end process;
           
    --Assignation des sorties
    TRNSMTP <= TRNSMTP_s; 
    TSTARTP <= TSTARTP_s;
    TREADDP <= TREADDP_s;
    TDONEP  <= TDONEP_s;
end behavioral;  