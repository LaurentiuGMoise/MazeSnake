library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGACtrl is
    Port (
        clk        : in STD_LOGIC;  -- 25 MHz pixel clock from DE1-SoC Clock Divider
        VGA_BLANK  : out STD_LOGIC; -- Blanking signal
        C_Sync_N   : out STD_LOGIC; -- Sync_n signal (inverted sync signal)
        VGA_HSYNC  : out STD_LOGIC;
        VGA_VSYNC  : out STD_LOGIC;
        VGA_RED    : out STD_LOGIC_VECTOR(7 downto 0);
        VGA_GREEN  : out STD_LOGIC_VECTOR(7 downto 0);
        VGA_BLUE   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end VGACtrl;

architecture Behavioral of VGACtrl is
    signal h_count, v_count : integer := 0;
    signal TVGA_HSYNC : std_logic := '0';
    signal TVGA_VSYNC : std_logic := '0';
    signal Sync_N     : std_logic := '0';
    signal BLNK       : std_logic := '0';

    constant H_RES         : integer := 800;  -- Horizontal resolution
    constant V_RES         : integer := 600;  -- Vertical resolution
    constant H_SYNC        : integer := 96;   -- Sync pulse width
    constant H_FRONT_PORCH : integer := 16;   -- Front porch width
    constant H_BACK_PORCH  : integer := 48;   -- Back porch width
    constant V_SYNC        : integer := 2;    -- Sync pulse width
    constant V_FRONT_PORCH : integer := 10;   -- Front porch width
    constant V_BACK_PORCH  : integer := 33;   -- Back porch width

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if h_count < H_RES + H_SYNC + H_FRONT_PORCH + H_BACK_PORCH then
                h_count <= h_count + 1;
            else
                h_count <= 0;

                if v_count < V_RES + V_SYNC + V_FRONT_PORCH + V_BACK_PORCH then
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
                end if;
            end if;

            if (h_count >= H_SYNC + H_BACK_PORCH and h_count < H_RES + H_SYNC + H_FRONT_PORCH + H_BACK_PORCH) then
                TVGA_HSYNC <= '1';
            else
                TVGA_HSYNC <= '0';
            end if;

            if (v_count >= V_SYNC + V_BACK_PORCH and v_count < V_RES + V_SYNC + V_FRONT_PORCH + V_BACK_PORCH) then
                TVGA_VSYNC <= '1';
            else
                TVGA_VSYNC <= '0';
            end if;

            if (h_count >= 200 and h_count < 600) or (v_count >= 100 and v_count < 500) then
                -- Display square in the center of the screen
                VGA_RED   <= "11111111";
                VGA_GREEN <= "00000000";
                VGA_BLUE  <= "00000000";
            else
                -- Display background color outside the square
                VGA_RED   <= "00000000";
                VGA_GREEN <= "00000000";
                VGA_BLUE  <= "00000000";
            end if;

            if (h_count >= H_RES + H_SYNC) or (h_count < H_SYNC + H_BACK_PORCH) then
                BLNK <= '1';
            else 
                BLNK <= '0';
            end if;

        end if;
    end process;

    C_Sync_N <= NOT Sync_N;
    VGA_HSYNC <= TVGA_HSYNC;
    VGA_VSYNC <= TVGA_VSYNC;
    VGA_BLANK <= BLNK;

end Behavioral;
