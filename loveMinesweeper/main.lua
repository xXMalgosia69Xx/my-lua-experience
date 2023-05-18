function love.load()
  function reset()
    game_state = state.STARTED
    bomb_count = 10
    mark_count = 0
    time = 0
    num_board = {}
    state_board = {}

    for y=1,9 do   
      num_board[y] = {}
      state_board[y] = {}
      for x=1,9 do
        num_board[y][x] = 0
        state_board[y][x] = state.DEFAULT
      end
    end

    local b = 0
    repeat
      local j,n = math.random(9),math.random(9)
      if num_board[j][n] ~= 9 then
        num_board[j][n] = 9
        b = b + 1
      end
    until b == bomb_count

    function count_cells()
      for y=1,9 do
        for x=1,9 do
          if num_board[y][x] ~= 9 then
            for i=-1,1 do
              for j=-1,1 do
                if y + i == 0 or y + i == 10 then break end
                if x + j == 0 or x + j == 10 then goto skip end
                if num_board[y+i][x+j] == 9 then num_board[y][x] = num_board[y][x] + 1 end
                ::skip::
              end
            end
          end
        end
      end
    end

    count_cells()

  end

  math.randomseed(os.clock()*100000000000)

  texture = {}
  sounds = {}
  colors = {{r = 0, g = 0.1, b = 1}, {r = 0, g = 190/255, b = 0}, {r = 1, g = 0, b = 0.1}, {r = 0, g = 60/255, b = 156/255}, {r = 235/255, g = 52/255, b = 52/255}}

  state = {DEFAULT = 1, CLICKED = 2, HOLDED = 3, MARKED = 4, STARTED = 5, ONGOING = 6, LOST = 7, WON = 8}

  bomb_count = 10  
  time, timer = 0, 0
  is_button_down = false
  is_mouse_down = false
  is_mark_down = false
  cell_size = 24
  game_state = state.STARTED

  texture.cell = love.graphics.newImage("res/images/cell.jpg")
  texture.background = love.graphics.newImage("res/images/background.png")
  texture.flag = love.graphics.newImage("res/images/marked_cell.jpg")
  texture.bomb = love.graphics.newImage("res/images/bomb_cell.jpg")
  texture.button_up = love.graphics.newImage("res/images/retry_up.png")
  texture.button_down = love.graphics.newImage("res/images/retry_down.png")
  texture.button_lost = love.graphics.newImage("res/images/retry_lost.png")
  texture.button_won = love.graphics.newImage("res/images/retry_won.png")

  sounds.bura = love.audio.newSource("res/sounds/bura.mp3", "static")
  sounds.buu = love.audio.newSource("res/sounds/buu.mp3", "static")
  sounds.nya = love.audio.newSource("res/sounds/nya.mp3", "static")

  time_font = love.graphics.newFont("res/fonts/fnt.otf", 40)
  cell_font = love.graphics.newFont("res/fonts/fnt.otf", 40)
  small_font = love.graphics.newFont("res/fonts/fnt.otf", 4)

  reset()
end

function clear_zeros()
  for _=1,16 do
    local k = 0
    for y=1,9 do
      for x=1,9 do
        if num_board[y][x] == 9 and state_board[y][x] == state.CLICKED then game_state = state.LOST sounds.buu:play() end
        if num_board[y][x] == 0 and state_board[y][x] == state.CLICKED then
          for i=-1,1 do
            for j=-1,1 do
              if y + i == 0 or y + i == 10 then break end
              if x + j == 0 or x + j == 10 then goto skip end
              state_board[y+i][x+j] = state.CLICKED
              ::skip::
            end
          end
        end
        if state_board[y][x] == state.CLICKED then k = k + 1 end
      end
    end
    if k == 9 * 9 - bomb_count then game_state = state.WON sounds.bura:play() end
  end
end

function love.update(dt)
  if game_state == state.ONGOING then
    timer = timer + dt
    if timer > 1 and time < 999 then
      sounds.nya:play()
      time = time + 1
      timer = 0
    end
  end

  local m_x, m_y = love.mouse.getPosition()
  if love.mouse.isDown(1) then

    if m_x > 130 - texture.button_up:getWidth()/2 
    and m_x < 130 + texture.button_up:getWidth()/2 
    and m_y > 42 and m_y < 42 + texture.button_up:getWidth() 
    and is_mouse_down == false then
      is_button_down = true
      is_mouse_down = true
    end
    if game_state == state.ONGOING or game_state == state.STARTED then
      for y=1,9 do
        for x=1,9 do
          if m_x > x * cell_size and m_x < (x+1) * cell_size
          and m_y > y * cell_size + 99 and m_y < (y+1) * cell_size + 99 
          and state_board[y][x] == state.DEFAULT and is_mouse_down == false then
            state_board[y][x] = state.HOLDED
            is_mouse_down = true
          end
        end
      end
    end
  else
    if m_x > 130 - texture.button_up:getWidth()/2
      and m_x < 130 + texture.button_up:getWidth()/2
      and m_y > 42 and m_y < 42 + texture.button_up:getWidth() 
      and is_button_down == true then
        reset()
        is_button_down = false
    else
        is_button_down = false
        is_mouse_down = false
    end
    if game_state == state.ONGOING or game_state == state.STARTED then
      for y=1,9 do
        for x=1,9 do
          if state_board[y][x] == state.HOLDED then
            if m_x > x * cell_size and m_x < (x+1) * cell_size
            and m_y > y * cell_size + 99 and m_y < (y+1) * cell_size + 99 then
              if game_state == state.STARTED then game_state = state.ONGOING end
              state_board[y][x] = state.CLICKED
              clear_zeros()
            else
              state_board[y][x] = state.DEFAULT
            end
          end
        end
      end
    end
  end
  if love.mouse.isDown(2) then
    if game_state == state.ONGOING or game_state == state.STARTED then
      for y=1,9 do
        for x=1,9 do
          if m_x > x * cell_size and m_x < (x+1) * cell_size
          and m_y > y * cell_size + 99 and m_y < (y+1) * cell_size + 99 
          and is_mark_down == false then
            if state_board[y][x] == state.DEFAULT then 
              state_board[y][x] = state.MARKED
              mark_count = mark_count + 1
              is_mark_down = true
            elseif state_board[y][x] == state.MARKED then
              state_board[y][x] = state.DEFAULT
              mark_count = mark_count - 1
              is_mark_down = true
            end
          end
        end
      end
    end
  else
    is_mark_down = false
  end
end

function love.draw()
  love.graphics.reset()
  love.graphics.draw(texture.background, 0, 0)
  for y=1,9 do
    for x=1,9 do
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", x * cell_size - 2, y * cell_size + 99, cell_size, cell_size)

      love.graphics.reset()
      if state_board[y][x] == state.DEFAULT then
        love.graphics.draw(texture.cell, x * cell_size - 2, y * cell_size + 99)
      elseif state_board[y][x] == state.CLICKED then
        if num_board[y][x] == 9 then
          love.graphics.draw(texture.bomb, x * cell_size - 2, y * cell_size + 99)
        elseif num_board[y][x] ~= 0 then
          local color = colors[num_board[y][x]]
          love.graphics.setColor(color.r, color.g, color.b)
          love.graphics.print(""..num_board[y][x], x * cell_size + 5, y * cell_size + 103)

          love.graphics.reset()
        end
      elseif state_board[y][x] == state.MARKED then
        love.graphics.draw(texture.flag, x * cell_size - 2, y * cell_size + 99)
      end
    end
  end
  if is_button_down ~= true then
    if game_state == state.LOST then
      love.graphics.draw(texture.button_lost, 130 - texture.button_up:getWidth()/2, 42)
    elseif game_state == state.WON then
      love.graphics.draw(texture.button_won, 130 - texture.button_up:getWidth()/2, 42)
    else
      love.graphics.draw(texture.button_up, 130 - texture.button_up:getWidth()/2, 42)
    end
  else
    love.graphics.draw(texture.button_down, 130 - texture.button_up:getWidth()/2, 42)
  end
  love.graphics.setColor(0, 0, 0)
  local zeros
  if time < 10 then zeros = "00" elseif time < 100 then zeros = "0" else zeros = "" end
  love.graphics.printf(zeros..""..time, time_font, 24, 40, 70, "right")
  love.graphics.printf("time", 38, 73, 50, "center")
  
  love.graphics.printf(bomb_count-mark_count.."", time_font, 160, 45, 70, "center")
end