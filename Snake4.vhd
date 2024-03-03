library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Snake4 is
    Port (
        clk_50 : in STD_LOGIC;  -- 50 MHz clock from DE1-SoC
        -- Add other ports as needed
        VGA_HSYNC : out STD_LOGIC;
        VGA_VSYNC : out STD_LOGIC;
        VGA_RED, VGA_GREEN, VGA_BLUE : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Snake4;

