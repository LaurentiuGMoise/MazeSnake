library ieee;
use ieee.std_logic_1164.all;
use     IEEE.numeric_std.all; 

entity CLKDIV is
port(
clk_50MHz : in STD_LOGIC;
pxlclk    : out STD_LOGIC;
gmclk     : out STD_LOGIC
);

end CLKDIV;

architecture dflow of CLKDIV is

constant divider_4Hz : integer := 2000000;

signal TCLK : std_logic := '0';
signal T4Hz : std_logic := '0';
signal Cnt4Hz : integer range 0 to divider_4Hz;


begin

process(Clk_50MHz) 
begin

	if rising_edge(clk_50MHz) then
		Cnt4Hz <= Cnt4Hz + 1;
	
		if (Cnt4Hz > divider_4Hz) then
		
			T4Hz <= not T4Hz;
			Cnt4Hz <= 0;
		
		end if;
	TCLK <= not TCLK;
	
	end if;


end process;

pxlclk <= TCLK;
gmclk  <= T4Hz;

end dflow;
