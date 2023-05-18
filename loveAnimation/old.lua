--[[animationMod = require("bin/Animation")
local player = require("bin/Player")
local newplayer = require("bin/newPlayer")
local lg = love.graphics

function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")

  PlayerAnimations = {
    ["idle"] = animationMod:newAnimation(lg.newImage("assets/Knight/KnightIdle.png"), 100, 64, 1, true),
    ["running"] = animationMod:newAnimation(lg.newImage("assets/Knight/KnightRun.png"), 100, 64, 1, true),
    --["attack"] = animationMod:newAnimation(lg.newImage("assets/attack.png"), 31, 28, 0.3, false)
  }
  EnvironmentTextures = {
    ["grass"] = lg.newImage("assets/env/grass.png"),
    ["decor"] = lg.newImage("assets/env/decor.png"),
  }

  decorQuads = animationMod:newAnimation(EnvironmentTextures["decor"], 16, 16, 0)

  resetDecor()

  --Player = player:newPlayer({x = 100, y = 100}, PlayerAnimations, 1.6)
  Player = newplayer:newCharacter({x = 100, y = 100}, PlayerAnimations, {"idle", "running"}, 1.6)
end

function resetDecor()
  Decor = {}
  for i = 1, 15 do
    Decor[i] = {}
    for j = 1, 15 do
      Decor[i][j] = 0
    end
  end
  for _ = 1, 15 do
    Decor[math.random(15)][math.random(15)] = math.random(#decorQuads.quads)
  end
end

function love.keypressed(key)
  -- if key equals r then reset the decor table
  if key == "r" then
    resetDecor()
  end
  if key == "up" then
    Player:changeSpriteSize(3)
  elseif key == "down" then
    Player:changeSpriteSize(0.5)
  end
  -- if any key is down set animation to running
  -- if love.keyboard.isDown("a", "d", "w", "s") and not Player.attacking then Player.currentAnimation = "running" end
  Player:keyDown(key)
end

function love.keyreleased(key)
  -- if no keys are down set animation to idle
  -- if not love.keyboard.isDown("a", "d", "w", "s") and not Player.attacking then Player.currentAnimation = "idle" end
  Player:keyUp(key)
end

function love.update(dt)
  Player:update(dt)
end

function love.mousepressed(x, y, button)
  --Player:mouse(x, y, button)
end
--]]
--[[
function love.draw()
  -- draw 15 by 15 grid of grass texture
  for i = 0, 15 * 16, 16 do
    for j = 0, 15 * 16, 16 do
      lg.draw(EnvironmentTextures["grass"], i, j)
    end
  end
  -- loop through decor table and draw decor quads
  for i = 1, 15 do
    for j = 1, 15 do
      if Decor[i][j] ~= 0 then
        lg.draw(EnvironmentTextures["decor"], decorQuads.quads[Decor[i][j]]--[[, (i-1) * 16, (j-1) * 16)
      end
    end
  end

  Player:draw()

  -- debug values
  lg.print(Player.direction.x..", "..Player.direction.y, 0, 0)
  lg.print(Player.position.x..", "..Player.position.y, 0, 20)
  boolasnum = Player.attacking and 1 or 0
  lg.print(boolasnum.."", 0, 40)
end
--]]