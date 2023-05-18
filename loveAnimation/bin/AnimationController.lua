AnimationController = {}

function AnimationController:newAnimationController(animations, indexes)
  local animationController = {}

  animationController.animations = animations
  animationController.currentAnimation = indexes[1]
  animationController.currentAnimationIndex = 1
  animationController.animationIndexes = indexes
  animationController.spriteOrientation = 1

  local lookUpAnimationIndex = function(animationName)
    for i, animation in ipairs(animationController.animationIndexes) do
      if animation == animationName then
        return i
      end
    end
  end

  function animationController:changeSpriteSize(scale)
    for _, animation in pairs(self.animations) do
      animation.drawScale = scale
    end
  end

  function animationController:draw(position)
    self.animations[self.currentAnimation]:draw(position, self.spriteOrientation)
  end

  function animationController:update(dt)
    self.animations[self.currentAnimation]:update(dt)

    if self.animations[self.currentAnimation].currentTime >= self.animations[self.currentAnimation].duration and self.animations[self.currentAnimation].repeating ~= true then
      self.animations[self.currentAnimation]:reset()
      self.changeAnimation(self.animationIndexes[1])
    end
  end

  function animationController:changeAnimation(animationName)
    self.currentAnimation = animationName
    self.currentAnimationIndex = lookUpAnimationIndex(animationName)
    self.animations[self.currentAnimation]:reset()
  end



  return animationController
end

return AnimationController