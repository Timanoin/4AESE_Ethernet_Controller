-- Compteur 16 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity emetteur is
    port (TABORTP, TAVAILP, TFINISHP, TLASTP, CLK, CLK8, RESET : in std_logic;
          TDATAI  : in std_logic_vector(7 downto 0);
          TSTARTP, TREADDP, TDONEP, TRNSMTP  : out std_logic;
          TDATAO : out std_logic_vector(7 downto 0));
end emetteur;

constant SFD : std_logic_vector(7 downto 0) = "10101011";
constant EFD : std_logic_vector(7 downto 0) = "01010100";

architecture behavioral of emetteur is 
signal TRNSMTP_s : std_logic = '0'; 
signal TSTARTP_s : std_logic = '0'; 
begin 
    process (TAVAILP)
    begin
        if rising_edge(TAVAILP) then
            TRNSMTP_s <= '1';
            TSTARTP <= '1';
            if TSTART ='1' then
                TSTART ='0';
            end if;
        end if ; 
    end process;
    process (CLK8)
    begin 

    end process; 
    --ASSIGNATION SORTIES
    TRNSMTP <= TRNSMTP_s; 
end behavioral;  