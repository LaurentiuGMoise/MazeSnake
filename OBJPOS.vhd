library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OBJPOS is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        -- Add other ports as needed
        objectX : out INTEGER;  -- X position of the object
        objectY : out INTEGER   -- Y position of the object
    );
end OBJPOS;

architecture Behavioral of OBJPOS is
    signal objectX_internal, objectY_internal : INTEGER := 0;

    -- Object movement parameters
    constant MOVE_SPEED : INTEGER := 1;

    -- Collision detection parameters
    constant COLLISION_X : INTEGER := 100;  -- X coordinate for collision detection
    constant COLLISION_Y : INTEGER := 200;  -- Y coordinate for collision detection
    signal collision_flag : STD_LOGIC := '0';  -- Flag indicating collision

begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset object position and collision flag when reset signal is asserted
            objectX_internal <= 0;
            objectY_internal <= 0;
            collision_flag <= '0';
        elsif rising_edge(clk) then
            -- Update object position based on your design or game logic
            -- For example, move the object to the right at a constant speed
            objectX_internal <= objectX_internal + MOVE_SPEED;

            -- Check for collision with a specific pixel location
            if objectX_internal = COLLISION_X and objectY_internal = COLLISION_Y then
                collision_flag <= '1';  -- Collision detected
            else
                collision_flag <= '0';  -- No collision
            end if;
        end if;
    end process;

    -- Assign the internal object positions to the output ports
    objectX <= objectX_internal;
    objectY <= objectY_internal;

    -- Additional output for collision flag
    collision_detected <= collision_flag;

end Behavioral;