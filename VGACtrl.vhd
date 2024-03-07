library IEEE;
use     IEEE.std_logic_1164. all;
use     IEEE.numeric_std.    all; 

entity VGASync is

  Port (pxlclk : in  std_logic;
		  Csync  : out std_logic;
		  Blank  : out std_logic;
		  Hsync  : out std_logic;
		  Vsync  : out std_logic;
        xpos   : out integer range 0 to 800;
        ypos   : out integer range 0 to 525
		);
end entity; 

architecture MAIN of VGASync is 

signal T_Hsync : std_logic := '0';
signal T_Vsync : std_logic := '0';
signal T_Blank : std_logic := '0';
signal HPos       : integer range 0 to 800 := 0;	-- Total number of horizontal pixels 
signal VPos       : integer range 0 to 525 := 0;	-- Total number of vertical lines 


begin

  Pixels : process  (pxlclk)						
  
  begin 
    if rising_edge (pxlclk) then
	 
      if (HPos < 800) then
        HPos <= HPos + 1;  							
		  
      else 
		
        HPos <= 0;										
		  
        if (VPos < 525) then 							
           VPos <= VPos + 1;							
        else 
           VPos <= 0;  									
        end if;
		  
      end if;
	 
	
      if (HPos < 95) then T_Hsync <= '0';		
      else                T_Hsync <= '1';
      end if;
	 
      if (VPos < 2 ) then T_Vsync <= '0';		
      else                T_Vsync <= '1';
      end if;
		
		
      if ((HPos > 142 AND HPos < 783 ) and 
          (VPos >  35 AND VPos < 516)) then 		
        T_Blank <= '1';
      else 
        T_Blank <= '0';
      end if;
		
    end if;

  end process Pixels;

  xpos <= HPos ;								-- Return the pixel positions relative to zero, rather then 
  ypos <= VPos ;									--   relative to the start of the line/frame
  Blank   <= T_Blank;
  Hsync   <= T_Hsync;
  Vsync   <= T_Vsync;
  CSync   <= '0';											-- It turns out that composite sync isn't needed by the DAC, so set it to 0
			
end architecture; 