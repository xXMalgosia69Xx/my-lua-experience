local animationMod = require("bin/Animation")

local playerAnimations = {
  ["idle"] = animationMod:newAnimation(lg.newImage("assets/Knight/KnightIdle.png"), 100, 64, 1, true),
  ["running"] = animationMod:newAnimation(lg.newImage("assets/Knight/KnightRun.png"), 100, 64, 1, true),
}

