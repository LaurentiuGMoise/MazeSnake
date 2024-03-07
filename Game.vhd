library ieee;
use ieee.std_logic_1164.all;

entity Snake6 is
port(
Clk_50MHz:  in std_logic;
Btn_R    :  in std_logic;
SW_DIR   :  in std_logic;
SW_UP    :  in std_logic;
SW_DWN   :  in std_logic;
SW_R     :  in std_logic;
pxlclk_o : out std_logic;
Csync    : out std_logic;
Blank    : out std_logic;
Hsync    : out std_logic;
Vsync    : out std_logic;
VGA_R    : out std_logic_vector(7 downto 0);
VGA_G    : out std_logic_vector(7 downto 0);
VGA_B    : out std_logic_vector(7 downto 0)
);

end Snake6;


architecture Top of Snake6 is

component CLKDIV is
port(
clk_50MHz : in STD_LOGIC;
pxlclk    : out STD_LOGIC;
gmclk     : out STD_LOGIC
);

end component CLKDIV;

component VGASync is
port(
pxlclk : in  std_logic;
Csync  : out std_logic;
Blank  : out std_logic;
Hsync  : out std_logic;
Vsync  : out std_logic;
xpos   : out integer range 0 to 800;
ypos   : out integer range 0 to 525
);

end component VGASync;


signal Pixel_Clock : std_logic := '0';
signal Game_Clock : std_logic := '0';

signal xpxl : integer range 0 to 800;
signal ypxl : integer range 0 to 800;

signal xpxl1 : integer := 150;
signal ypxl1 : integer := 200;
signal xpxl2 : integer := 200;
signal ypxl2 : integer := 250;


----BLOCKS TO MAKE UP THE MAZE-----


signal xpxl1_block1: integer := 150;
signal xpxl2_block1: integer := 200;
signal ypxl1_block1: integer := 150;
signal ypxl2_block1: integer := 230;


signal xpxl1_block2: integer := 300;
signal xpxl2_block2: integer := 350;
signal ypxl1_block2: integer := 260;
signal ypxl2_block2: integer := 300;

signal xpxl1_block3: integer := 250;
signal xpxl2_block3: integer := 280;
signal ypxl1_block3: integer := 300;
signal ypxl2_block3: integer := 330;


signal winblockx1: integer := 550;
signal winblockx2: integer := 600;
signal winblocky1: integer := 4;
signal winblocky2: integer := 484;





----BLOCKS TO MAKE UP THE MAZE-----


----BLOCK TO MAKE UP THE SNAKE-----

signal snakex1 : integer :=110;
signal snakex2 : integer :=115;
signal snakey1 : integer :=200;
signal snakey2 : integer :=205;

signal msnakex1 : integer :=80;
signal msnakex2 : integer :=110;
signal msnakey1 : integer :=400;
signal msnakey2 : integer :=405;





----BLOCK TO MAKE UP THE SNAKE-----

----TEMP BLOCKS----

signal Tsnakex1 : integer :=110;
signal Tsnakex2 : integer :=115;
signal Tsnakey1 : integer :=200;
signal Tsnakey2 : integer :=205;

signal MTsnakex1 : integer :=80;
signal MTsnakex2 : integer :=110;
signal MTsnakey1 : integer :=400;
signal MTsnakey2 : integer :=405;



----TEMP BLOCKS----

signal SquareSpeed : integer := 1;  -- Speed of the snake movement

signal Direction   : std_logic := '1';  -- Direction: '1' for right, '0' for left

signal Collision   : std_logic := '0'; -- Collision Flag

begin

Div : CLKDIV port map (Clk_50MHz, Pixel_Clock, Game_Clock);
Sync : VGASync port map (Pixel_Clock, Csync, Blank, Hsync, Vsync, xpxl, ypxl);
		

l_draw : process (Pixel_Clock)
begin
    if rising_edge(Pixel_Clock) then
        if ((xpxl >= xpxl1_block1 and xpxl <= xpxl2_block1) and (ypxl >= ypxl1_block1 and ypxl <= ypxl2_block1)) or
           ((xpxl >= xpxl1_block2 and xpxl <= xpxl2_block2) and (ypxl >= ypxl1_block2 and ypxl <= ypxl2_block2)) or
			  ((xpxl >= xpxl1_block3 and xpxl <= xpxl2_block3) and (ypxl >= ypxl1_block3 and ypxl <= ypxl2_block3))
			 then
			  
            VGA_R <= "11111111";
            VGA_G <= "00000000";
            VGA_B <= "00000000";
				
		  elsif ((xpxl >= snakex1 and xpxl <= snakex2)  and  (ypxl>= snakey1 and ypxl <= snakey2)) or
		        ((xpxl>= msnakex1 and xpxl <= msnakex2) and (ypxl>=msnakey1 and ypxl <=msnakey2)) then

            VGA_R <= "00000000";
            VGA_G <= "11111111";
            VGA_B <= "00000000";	  
				
		 elsif((xpxl >= winblockx1 and xpxl <= winblockx2) and (ypxl >= winblocky1 and ypxl <= winblocky2)) then
		 		  
            VGA_R <= "11111111";
            VGA_G <= "00000000";
            VGA_B <= "11111111";	  
				
       else 
		  
            VGA_R <= "00000000";
            VGA_G <= "00000000";
            VGA_B <= "00000000";
				
		  end if;
		  
				
		 
    end if;

end process;

 x_move : process (Game_Clock)
    begin
        if rising_edge(Game_Clock) then
            if SW_R = '1' then
                -- Reset the snake's position and direction when the switch is pressed
                Tsnakex1 <= 110;
                Tsnakex2 <= 115;
                Tsnakey1 <= 200;
                Tsnakey2 <= 205;
					 
             
					 MTsnakex1 <=80;
					 MTsnakex2 <=110;
					 MTsnakey1 <=200;
					 MTsnakey2 <=205;
					 
					 
					 
				    Direction <= '1';  -- Reset direction to right
					 
            else
                -- Move the snake based on the current direction
                if Direction = '1' then
					 
                    Tsnakex1 <= Tsnakex1 + SquareSpeed;
                    Tsnakex2 <= Tsnakex2 + SquareSpeed;
					
		              MTsnakex1 <= MTsnakex1 + SquareSpeed;
						  MTsnakex2 <= MTsnakex2 + SquareSpeed;
						
						  
						  
                elsif Direction = '0' then
					 
                    Tsnakex1 <= Tsnakex1 - SquareSpeed;
                    Tsnakex2 <= Tsnakex2 - SquareSpeed;
						  
		              MTsnakex1 <= MTsnakex1 - SquareSpeed;
						  MTsnakex2 <= MTsnakex2 - SquareSpeed;

						  
                end if;
					 

                -- Check for screen boundary to stop the snake and change direction
					 
                if Tsnakex2 > 640 or MTSnakex2 > 640 then
					 
                    Tsnakex1 <= 110;
                    Tsnakex2 <= 115;
						  
						  MTsnakex1 <=80;
					     MTsnakex2 <=110;
					     MTsnakey1 <=200;
					     MTsnakey2 <=205;
						  
						  
						  
                elsif Tsnakex1 < 0 or MTSnakex1 < 0 then
					 
                    Tsnakex1 <= 110;
                    Tsnakex2 <= 115;
						  
						  MTsnakex1 <=80;
					     MTsnakex2 <=110;
					     MTsnakey1 <=200;
					     MTsnakey2 <=205;
						  
						  
                end if;
					 
					 if SW_DIR = '1' then
					 
						Direction <= '1';
						
					 elsif SW_DIR = '0' then
				
						Direction <='0';
						
					 end if;
					 
					 -- Move the snake up or down based on the new switch inputs
					 
					if SW_UP = '1' then
					
						Tsnakey1 <= Tsnakey1 - SquareSpeed;
						Tsnakey2 <= Tsnakey2 - SquareSpeed;
					
					   MTsnakey1 <= MTsnakey1 - SquareSpeed;
						MTsnakey2 <= MTsnakey2 - SquareSpeed;
												

						
					elsif SW_DWN = '1' then
					
						Tsnakey1 <= Tsnakey1 + SquareSpeed;
						Tsnakey2 <= Tsnakey2 + SquareSpeed;
						
		            MTsnakey1 <= MTsnakey1 + SquareSpeed;
						MTsnakey2 <= MTsnakey2 + SquareSpeed;
						
						
						
					else
						Tsnakey1 <= Tsnakey1;
						Tsnakey2 <= Tsnakey2;
						
						MTsnakey1 <= MTsnakey1;
						MTsnakey2 <= MTsnakey2; 

					end if;
	
			if ((Tsnakex2 >= xpxl1_block1 and Tsnakex1 <= xpxl2_block1) and
				(Tsnakey2 >= ypxl1_block1 and Tsnakey1 <= ypxl2_block1)) or
				((Tsnakex2 >= xpxl1_block2 and Tsnakex1 <= xpxl2_block2) and
				(Tsnakey2 >= ypxl1_block2 and Tsnakey1 <= ypxl2_block2)) or
				((Tsnakex2 >= xpxl1_block3 and Tsnakex1 <= xpxl2_block3) and
				(Tsnakey2 >= ypxl1_block3 and Tsnakey1 <= ypxl2_block3)) or
				(Tsnakex1 <= xpxl1_block1 and Tsnakex2 >= xpxl2_block1 and
				Tsnakey1 <= ypxl1_block1 and Tsnakey2 >= ypxl2_block1) or
				(Tsnakex1 <= xpxl1_block2 and Tsnakex2 >= xpxl2_block2 and
				Tsnakey1 <= ypxl1_block2 and Tsnakey2 >= ypxl2_block2) or
				(Tsnakex1 <= xpxl1_block3 and Tsnakex2 >= xpxl2_block3 and
				Tsnakey1 <= ypxl1_block3 and Tsnakey2 >= ypxl2_block3) then
					 
		
                -- Collision detected, set the flag
                Collision <= '1';
					 
					 
               else
				
                -- No collision, reset the flag
					 
                Collision <= '0';
					 
            end if;
	
				if Collision = '1' then
				
				    Tsnakex1 <= 110;
                Tsnakex2 <= 115;
                Tsnakey1 <= 200;
                Tsnakey2 <= 205;
					 
					 MTsnakex1 <=80;
					 MTsnakex2 <=110;
					 MTsnakey1 <=200;
					 MTsnakey2 <=205;
					 

				end if;
					
            end if;
        end if;
    end process;

    snakex1 <= Tsnakex1;
    snakex2 <= Tsnakex2;
	 snakey1 <= Tsnakey1;
	 snakey2 <= Tsnakey2;
	 
	 msnakex1 <= MTsnakex1;
    msnakex2 <= MTsnakex2;
	 msnakey1 <= MTsnakey1;
	 msnakey2 <= MTsnakey2;

    pxlclk_o <= Pixel_Clock;

end architecture;