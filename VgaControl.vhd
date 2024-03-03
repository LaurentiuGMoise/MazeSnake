Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity VGACONTROL is
    Port (
        clk_50 : in STD_LOGIC;  -- 50 MHz clock from DE1-SoC
        VGA_HSYNC : out STD_LOGIC;
        VGA_VSYNC : out STD_LOGIC;
        VGA_RED, VGA_GREEN, VGA_BLUE : out STD_LOGIC_VECTOR(3 downto 0)
    );
end VGACONTROL;

architecture Behavioral of VGACONTROL is
    signal h_count, v_count : integer := 0;

    constant H_RES      : integer := 800;  -- Horizontal resolution
    constant V_RES      : integer := 600;  -- Vertical resolution
    constant H_SYNC     : integer := 128;  -- Sync pulse
    constant V_SYNC     : integer := 4;    -- Sync pulse
    constant CLK_FREQ   : integer := 50000000;  -- 50 MHz clock frequency
    constant PIXEL_CLK  : integer := 25000000;  -- 25 MHz pixel clock frequency

begin
    process(clk_50)
    begin
        if rising_edge(clk_50) then
            if h_count < H_RES + H_SYNC then
                h_count <= h_count + 1;
            else
                h_count <= 0;

                if v_count < V_RES + V_SYNC then
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
                end if;
            end if;

            IF (h_count >= H_SYNC and h_count < H_RES + H_SYNC) THEN

				VGA_HSYNC <= '1';

				ELSE
				VGA_HSYNC <= '0';
				END IF;
				
				IF (v_count >= V_SYNC and v_count < V_RES + V_SYNC) THEN

				VGA_VSYNC <= '1';

				ELSE
				VGA_VSYNC <= '0';

				END IF;
            -- Generate pixel data based on design
            -- Update VGA_RED, VGA_GREEN, VGA_BLUE accordingly
				if (h_count = 100 and v_count = 200) then
				-- Draw a red pixel at position (100, 200)
					VGA_RED   <= "1111";
					VGA_GREEN <= "0000";
					VGA_BLUE  <= "0000";
				else
					-- For other pixels, set the color to black or your desired background color
					VGA_RED   <= (others => '0');
					VGA_GREEN <= (others => '0');
					VGA_BLUE  <= (others => '0');
				end if;
end if;
        end if;
    end process;

end Behavioral;