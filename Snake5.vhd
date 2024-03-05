library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Snake5 is 
    Port (
        clk          : in  STD_LOGIC;
        VGA_BLANK    : out STD_LOGIC;
        C_Sync_N     : out STD_LOGIC;
        VGA_HSYNC    : out STD_LOGIC;
        VGA_VSYNC    : out STD_LOGIC;
        VGA_RED      : out STD_LOGIC_VECTOR(7 downto 0);
        VGA_GREEN    : out STD_LOGIC_VECTOR(7 downto 0);
        VGA_BLUE     : out STD_LOGIC_VECTOR(7 downto 0);
        clk_40Mhz    : out STD_LOGIC;
        clk_10hz     : out STD_LOGIC
    );
end Snake5;

architecture Behavioral of Snake5 is
    signal clk_40Mhz_temp, clk_10hz_temp : std_logic := '0';

    component CLKDIV is
        port (
            clk       : in  STD_LOGIC;
            clk_40MHz : out STD_LOGIC;
            clk_10hz  : out STD_LOGIC
        );
    end component;

    component VGACtrl is
        Port (
            clk        : in  STD_LOGIC;
            VGA_BLANK  : out STD_LOGIC;
            C_Sync_N   : out STD_LOGIC;
            VGA_HSYNC  : out STD_LOGIC;
            VGA_VSYNC  : out STD_LOGIC;
            VGA_RED    : out STD_LOGIC_VECTOR(7 downto 0);
            VGA_GREEN  : out STD_LOGIC_VECTOR(7 downto 0);
            VGA_BLUE   : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin 
    -- Instantiate Clock Divider
    CLKDIV_inst: CLKDIV
        port map (
            clk       => clk,
            clk_40MHz => clk_40MHz_temp,
            clk_10hz  => clk_10hz_temp
        );

    -- Instantiate VGA Controller
    VGACtrl_inst: VGACtrl
        port map (
            clk       => clk_40MHz_temp, -- Use the 40 MHz clock for VGA controller
            VGA_BLANK => VGA_BLANK,
            C_Sync_N  => C_Sync_N,
            VGA_HSYNC => VGA_HSYNC,
            VGA_VSYNC => VGA_VSYNC,
            VGA_RED   => VGA_RED,
            VGA_GREEN => VGA_GREEN,
            VGA_BLUE  => VGA_BLUE
        );

    -- Output the divided clocks
    clk_40MHz <= clk_40MHz_temp;
    clk_10hz  <= clk_10hz_temp;

end Behavioral;
