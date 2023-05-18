function love.load()
  math.randomseed(os.time())
  -- love configuration
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setNewFont(30)
  love.window.setMode(250, 250, {resizable=false, centered=true, vsync=true})
  love.window.setTitle("Snake")
  --love.graphics.setLineWidth(2)
  -- game variables
  GridSize = 10
  CellSize = 25

  function reset()
    SnakeParts = {
      { 4, 2 },
      { 3, 2 },
      { 2, 2 }
    }
    Direction = "right"
    Fruit = { 5, 5 }
    DirQueue = {}
    GameState = "playing"
    Score = 3
  end
  reset()
end

function newFruit()
  local newFruitPos =  { math.random(10), math.random(10) }
  local good = true
  repeat
    good = true
    for i=1,#SnakeParts do
      if newFruitPos[1] == SnakeParts[i][1] and newFruitPos[2] == SnakeParts[i][2] then 
        newFruitPos = { math.random(10), math.random(10) } 
        good = false
      end
    end
  until good == true
  return newFruitPos
end

function love.update(dt)
  timer = (timer or 0) + dt
  if timer > 0.25 and GameState == "playing" then
    if #SnakeParts == GridSize*GridSize then
      GameState = "won"
    end
    ::again::
    if #DirQueue ~= 0 then
      local k = table.remove(DirQueue, 1)
      if k == "w"  then 
        if  Direction ~= "down" then Direction = "up" else goto again end
      elseif k == "d" then
        if Direction ~= "left" then Direction = "right" else goto again end
      elseif k == "s" then
        if Direction ~= "up" then Direction = "down" else goto again end
      elseif k == "a" then
        if Direction ~= "right" then Direction = "left" else goto again end
      end
    end
    if Direction == "right" then 
      if SnakeParts[1][1] ~= 10 then
        table.insert(SnakeParts, 1, {SnakeParts[1][1]+1, SnakeParts[1][2]})
      else 
        table.insert(SnakeParts, 1, {1, SnakeParts[1][2]})
      end
    elseif Direction == "left" then
      if SnakeParts[1][1] ~= 1 then
        table.insert(SnakeParts, 1, {SnakeParts[1][1]-1, SnakeParts[1][2]})
      else
        table.insert(SnakeParts, 1, {10, SnakeParts[1][2]})
      end
    elseif Direction == "up" then
      if SnakeParts[1][2] ~= 1 then
        table.insert(SnakeParts, 1, {SnakeParts[1][1], SnakeParts[1][2]-1})
      else 
        table.insert(SnakeParts, 1, {SnakeParts[1][1], 10})
      end
    elseif Direction == "down" then
      if SnakeParts[1][2] ~= 10 then
        table.insert(SnakeParts, 1, {SnakeParts[1][1], SnakeParts[1][2]+1})
      else 
        table.insert(SnakeParts, 1, {SnakeParts[1][1], 1})
      end
    end
    if SnakeParts[1][1] == Fruit[1] and SnakeParts[1][2] == Fruit[2] then 
      Fruit = newFruit()
      Score = (Score or 3) + 1
    else
      table.remove(SnakeParts, #SnakeParts)
    end
    for k,s in ipairs(SnakeParts) do
      if s[1] == SnakeParts[1][1] and s[2] == SnakeParts[1][2] and k ~= 1 then GameState = "lost" end
    end
    timer = 0
  end
end

function love.keypressed(key)
  if key == "r" then reset() end
  table.insert(DirQueue, key.."")
end

function love.draw()
  for y=1,GridSize do
    for x=1,GridSize do
        -- Draw fruit // COLOR - RED
      if x == Fruit[1] and y == Fruit[2] then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", (x-1) * 25, (y-1) * 25, 25, 25)
      end
      for i,s in ipairs(SnakeParts) do
        -- Draw snake parts // COLOR - GREEN
        if s[1] == x and s[2] == y then
          love.graphics.setColor(0, 1, 0)
          love.graphics.rectangle("fill", (x-1) * 25, (y-1) * 25, 25, 25)
        if i == 1 then
          love.graphics.setColor(0, 0, 0)
          love.graphics.rectangle("line", (x-1) * 25, (y-1) * 25, 25, 25)
        end
        end
      end
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.rectangle("line", (x-1) * 25, (y-1) * 25, 25, 25)
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf(Score.."", 0, 0, 250, "center" )
    end
  end
end