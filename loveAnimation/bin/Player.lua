Player = {}

--- Create new Player object
---@param initPosition table # The initial position of the player.
---@param animations table # The animations of the player.
---@param spriteScale number # The scale of the player's sprite.
---@return table # The new Player object.
function Player:newPlayer(initPosition, animations, spriteScale)
    local player = {}

    player.pos = initPosition
    player.direction = {x = 0, y = 0}
    player.orientation = 1

    player.attacking = false

    player.animations = animations
    player.currentAnimation = "idle"
    
    for _, animation in pairs(player.animations) do
        animation.drawScale = spriteScale
    end

    --- Draw the player.
    ---@return nil
    function player:draw()
        local animation = self.animations[self.currentAnimation]
        --local quadNum = math.floor((animation.currentTime / animation.duration) * (#animation.quads)) + 1
        animation:draw(player.pos, self.orientation)
    end
    
    --- Update the player.
    ---@param dt number # The time since the last update.
    ---@return nil
    function player:update(dt)
        local animation = self.animations[self.currentAnimation]
        -- if direction.x is not 0 then orientation is direction.x
        if self.direction.x ~= 0 then
            self.orientation = self.direction.x
        end
        self.move(self, dt)
        animation:update(dt)
        -- if attacking and animation is not attacking then set animation to attacking, if not attacking and animation is attacking then set animation to idle
        if self.attacking and self.currentAnimation ~= "attack" then
            self.currentAnimation = "attack"
        elseif not self.attacking and self.currentAnimation == "attack" then
            --reset animation
            animation:reset()
            --self.currentAnimation = "idle"
        end
        -- if attacking and animation frame is finished then set attacking to false
        if self.attacking and animation.currentFrame > #animation.quads then
            self.attacking = false
        end
    end

    --- Key down event handler.
    ---@param key string # The key that was pressed.
    ---@return nil
    function player:keyDown(key)
        if love.keyboard.isDown("a", "d", "w", "s") and not self.attacking then
            self.currentAnimation = "running"
        end
        if key == "w" then
            self.direction.y = -1
        elseif key == "s" then
            self.direction.y = 1
        elseif key == "a" then
            self.direction.x = -1
        elseif key == "d" then
            self.direction.x = 1
        end
    end

    --- Key up event handler.
    ---@param key string # The key that was released.
    ---@return nil
    function player:keyUp(key)
        if not love.keyboard.isDown("a", "d", "w", "s") and not self.attacking then
            self.currentAnimation = "idle"
        end
        if (key == "w" and self.direction.y == -1) or (key == "s" and self.direction.y == 1) then
            self.direction.y = 0
        elseif (key == "a" and self.direction.x == -1) or (key == "d" and self.direction.x == 1) then
            self.direction.x = 0
        end
    end

    --- Player movement.
    ---@param dt number # The time since the last update.
    ---@return nil
    function player:move(dt)
        local mult = 100
        if self.direction.x ~= 0 and self.direction.y ~= 0 then mult = 71 end
        -- when direction.x or direction.y is not 0 then half the speed
        self.pos.x = self.pos.x + self.direction.x * dt * mult
        self.pos.y = self.pos.y + self.direction.y * dt * mult
    end

    --- Mouse event handler.
    ---@param x number # The x position of the mouse.
    ---@param y number # The y position of the mouse.
    ---@param button number # The button that was pressed.
    ---@return nil
    function player:mouse(x, y, button)
        if button == 1 then
            self.attacking = true
            self.currentAnimation = "attack"
        end
    end

    return player
end
return Player