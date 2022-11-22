-- Recepteur

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity recepteur is
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
end recepteur;

architecture behavioral of recepteur is 
    
    -- Signaux de sortie intermédiaires
    signal RBYTEP_s  : std_logic; 
    signal RCLEANP_s : std_logic; 
    signal RCNVGP_s  : std_logic; 
    signal RDONEP_s  : std_logic;
    signal RSTARTP_s : std_logic;
    -- Compteurs
    signal cmp_dest  : integer;
    signal cmp_src   : integer;
    signal cmp_clk   : std_logic_vector(7 downto 0); 
    signal clk_state : std_logic;
    -- Signaux booleens
    signal SFD_done  : bit;  
    signal src_done  : bit; 
    signal dest_done : bit;
    signal recep_done : bit;    
    -- Vecteurs constants
    constant SFD      : std_logic_vector(7 downto 0)  := "10101011";
    constant EFD      : std_logic_vector(7 downto 0)  := "01010100";
    constant ABORT_SEQ: std_logic_vector(7 downto 0)  := "10101010";
    constant ADDR_SRC : std_logic_vector(47 downto 0) := X"ABABABABABAB"; 
    
begin 
    -- Process synchrone sur la clock de base : 
    -- gestion des impulsions, 
    -- observation du début d'émission.
    process (CLK)
    begin
        if RESETN = '0' then
            RBYTEP_s  <= '0'; 
            RCLEANP_s <= '0'; 
            RDONEP_s  <= '0';
            RSTARTP_s <= '0';
            RCNVGP_s  <= '0';        
            RSMATIP_s <= '0';
            cmp_dest  <= '0';
            cmp_src   <= '0';
            cmp_clk   <= "00000011";
            clk_state <= '0';
            SFD_done  <= '0'; 
            src_done  <= '0'; 
            dest_done <= '0';
            recep_done <= '0';
        elsif rising_edge(CLK) and RENABP = '1' then
            -- Gestion des impulsions
            RBYTEP_s  <= '0';           
            RCLEANP_s <= '0';               
            RSTARTP_s <= '0';
            RDONEP_s  <= '0';
            -- Clock tous les 8 bits 
            if cmp_clk(2) = '1' and clk_state = '0' then  
                if  SFD_done = '0' then
                    if RDATAI = SFD then
                        RCVNGP_s <= '1';
                        RSTARTP_s <= '1';
                        SFD_done <= '1';
                    end if;
                elsif RCVNGP_s = '1' then
                    if dest_done = '0' then
                        if cmp_dest = '0' then
                            if RDATAI /= ADDR_DEST(47 downto 40) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            end if;
                        elsif cmp_dest = '1' then
                            if RDATAI /= ADDR_DEST(39 downto 32) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            end if;
                        elsif cmp_dest = '2' then
                            if RDATAI /= ADDR_DEST(31 downto 24) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            end if;
                        elsif cmp_dest = '3' then
                            if RDATAI /= ADDR_DEST(23 downto 16) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            end if;  
                        elsif cmp_dest = '4' then
                            if RDATAI /= ADDR_DEST(15 downto 8) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            end if;
                        elsif cmp_dest = '5' then
                            if RDATAI /= ADDR_DEST(7 downto 0) then
                                RCLEANP_s <= '1';
                                RDONEP_s <= '1';
                                RCVNGP_s <= '0';
                            else 
                                dest_done <= '1';
                                RSMATIP_s <= '1';
                            end if;    
                        end if;        
                        cmp_dest <= cmp_dest + 1;     
                    end if;   
                    -- Envoi l'adresse de la source
                    elsif src_done ='0' then
                        RDATAO <= RDATAI;                        
                        cmp_src <= cmp_src + 1;
                        RBYTEP_s <= '1';
                        if cmp_src = 5 then
                            src_done <= '1';
                            cmp_src <= 0;
                        end if;
                    -- Envoi des données
                    elsif recep_done = '0' then
                        RDATAO <= RDATAI;
                        RBYTEP_s <= '1';
                        if RDATAI = EFD then
                            recep_done <= '1';
                            RCVNGP_s <= '0';
                            RSMATIP_s <= '0';
                            RDONEP_s <= '1';
                            cmp_dest  <= '0';
                            cmp_src   <= '0';
                            cmp_clk   <= "00000011";
                            clk_state <= '0';
                            SFD_done  <= '0'; 
                            src_done  <= '0'; 
                            dest_done <= '0';
                            recep_done <= '0';
                        end if;
                    end if;
                end if; 
            end if;  
            -- incrémentation clock
            clk_state <= cmp_clk(2);
            cmp_clk <= cmp_clk + 1;     
        end if;
    end process;
 
   
    --Assignation des sorties
    RCVNGP  <= RCVNGP_s; 
    RDONEP  <= RDONEP_s;
    RBYTEP  <= RBYTEP_s;
    RCLEANP <= RCLEANP_s;
    RSMATIP <= RSMATIP_s;
    RSTARTP <= RSTARTP_s;
end behavioral;  