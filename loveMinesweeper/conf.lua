function love.conf(t)
  t.window.title = "I LOVE minesweeper"
  t.window.icon = "res/images/bomb_cell.jpg"

  t.window.width = 260
  t.window.height = 360
  t.window.resizable = false
  t.window.vsync = true
  t.window.centered = true

  t.console = false
  t.gammacorrect = false
end