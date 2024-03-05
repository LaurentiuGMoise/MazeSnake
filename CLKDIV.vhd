library ieee;
use ieee.std_logic_1164.all;

entity CLKDIV is 
    port (
        clk      : in  STD_LOGIC;
        clk_40MHz : out STD_LOGIC;
        clk_10Hz  : out STD_LOGIC
    );
end CLKDIV;

architecture Behavioral of CLKDIV is
    constant DIVIDER_40MHz : integer := 5;  -- 50 MHz to 40 MHz
    constant DIVIDER_10HZ  : integer := 4;  -- 50 MHz to 10 Hz

    signal Temp_40MHz : std_logic := '0';
    signal Temp_10Hz  : std_logic := '0';
    signal Count_40MHz : integer range 0 to DIVIDER_40MHz - 1 := 0;
    signal Count_10Hz  : integer range 0 to DIVIDER_10HZ  - 1 := 0;
  
begin 
    Divider : process (clk)
    begin
        if rising_edge(clk) then
            Count_40MHz <= Count_40MHz + 1;
            Count_10Hz  <= Count_10Hz + 1;

            if (Count_10Hz = DIVIDER_10HZ - 1) then
                Temp_10Hz  <= not Temp_10Hz;
                Count_10Hz <= 0;
            end if;

            if (Count_40MHz = DIVIDER_40MHz - 1) then
                Temp_40MHz  <= not Temp_40MHz;
                Count_40MHz <= 0;
            end if;
        end if;
    end process;

    clk_40MHz <= Temp_40MHz;
    clk_10Hz  <= Temp_10Hz;

end Behavioral;
