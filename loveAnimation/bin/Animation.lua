Animation = {}

--- Handles animation for a sprite.
---@param image love.Image # The image to create frames from.
---@param frameWidth number # The width of each frame.
---@param frameHeight number # The height of each frame.
---@return table # The frames.
function Animation:newAnimation(image, frameWidth, frameHeight, duration, repeatable)
  local animation = {}
  animation.quads = {}
  animation.spriteSheet = image
  animation.frameWidth = frameWidth;

  for y = 0, image:getHeight() - frameHeight, frameHeight do
    for x = 0, image:getWidth() - frameWidth, frameWidth do
      table.insert(animation.quads, love.graphics.newQuad(x, y, frameWidth, frameHeight, image:getDimensions()))
    end
  end

  animation.duration = duration or 0.5;
  animation.currentTime = 0;
  animation.currentFrame = 1;
  animation.repeatable = repeatable or false;
  animation.drawScale = 1;
  --animation.player = player;

  --- Draw the current frame of the animation.
  ---@param position table # The position to draw the frame at.
  ---@param direction number # The direction to draw the frame in.
  ---@return nil
  function animation:draw(position, direction)
    -- default direction to right
    if direction == 0 then direction = 1 end
    if self.currentFrame > #self.quads then self.currentFrame = 1 end
    love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], position.x, position.y, 0, direction * self.drawScale, self.drawScale, self.frameWidth / 2)
  end

  --- Update the animation.
  ---@param dt number # The time since the last update.
  ---@return nil
  function animation:update(dt)
    self.currentTime = self.currentTime + dt
    self.currentFrame = math.floor((animation.currentTime / animation.duration) * #animation.quads) + 1
    if self.currentTime > self.duration and self.repeatable then
      self.reset(self)
    end
  end

  --- Reset animation.
  ---@return nil
  function animation:reset()
    self.currentTime = 0
    self.currentFrame = 1
    self.currentQuadNum = 1
  end

  return animation
end

return Animation