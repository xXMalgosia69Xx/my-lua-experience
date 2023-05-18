animationConMod = require("bin/AnimationController")

Character = {}

function Character:newCharacter(position, animations, indexes, spriteScale)
  local character = {}

  character.position = position
  character.animations = animations
  character.animationController = animationConMod:newAnimationController(animations, indexes)

  character.animationController:changeSpriteSize(spriteScale)
  function character:changeSpriteSize(scale)
    self.animationController:changeSpriteSize(scale)
  end

  function character:draw()
    self.animationController:draw(self.position)
  end

  character.direction = {x = 0, y = 0}

  function character:update(dt)
    if self.direction.x ~= 0 then
      self.animationController.spriteOrientation = self.direction.x
    end
    self.animationController:update(dt)
    self.move(self, dt)
  end

  function character:keyDown(key)
    if love.keyboard.isDown("a", "d", "w", "s") and self.animationController.currentAnimation == "idle" then
      self.animationController:changeAnimation("running")
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
  function character:keyUp(key)
    if not love.keyboard.isDown("a", "d", "w", "s") and self.animationController.currentAnimation == "running" then
      self.animationController:changeAnimation("idle")
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
  function character:move(dt)
    local mult = 100
    if self.direction.x ~= 0 and self.direction.y ~= 0 then mult = 71 end
    -- when direction.x or direction.y is not 0 then half the speed
    self.position.x = self.position.x + self.direction.x * dt * mult
    self.position.y = self.position.y + self.direction.y * dt * mult
  end

    return character
end

return Character