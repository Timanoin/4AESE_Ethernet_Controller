library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity impulse_test is
end impulse_test;

architecture Behavioral of impulse_test is
-- Component Declaration for the Unit Under Test (UUT)
COMPONENT impulse
    PORT(
        CLK   : in std_logic;
        DATAI : in std_logic;
        DATAO : out std_logic
);
END COMPONENT;
--Inputs
signal CLK_s   : std_logic := '0';
signal DATAI_s : std_logic := '0';
--Outputs
signal DATAO_s : std_logic;
-- Clock period definitions
constant CLK_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: impulse PORT MAP (
        CLK => CLK_s,
        DATAI => DATAI_s,
        DATAO => DATAO_s
    );
    
    -- Clock process definitions
    Clock_process :process
    begin
        CLK_s <= not(CLK_s);
        wait for CLK_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- insert stimulus here
        DATAI_s <= '0', '1' after 50 ns, '0' after 70 ns, '1' after 100 ns, '0' after 150 ns, '1' after 170 ns;
        wait;
    end process;
end;