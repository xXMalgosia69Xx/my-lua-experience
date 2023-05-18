function love.keypressed(key)
    if key == "r" then Restart() end
    if key == "escape" then love.event.quit(0) end
    if key == "c" and not W then
        I = 0
        for i=0,#MoveQueue do
            Presentation[i] = MoveQueue[i]
        end
    end
end

function love.mousepressed(x, y)
    if W or I ~= 5 then return end
    local function pos(k)
        if k > 275/2 then return 2 end
        return 1
    end
    local px, py = pos(x), pos(y)

    local DPos = 2 * (py - 1) + px
    Beeps[DPos]:play()

    if DPos ~= MoveQueue[1] then
        W = true
    else
        Score = Score + 1
        table.insert(FadeQueue, {thing = MoveQueue[1], time = 0.5})
        table.remove(MoveQueue, 1)
    end

    if #MoveQueue == 0 then
        NextQueue()
    end
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setBackgroundColor(0, 0, 0)

    Beeps = {}
    Fnt = love.graphics.newFont(23)
    SFnt = love.graphics.newFont(15)

    for i=1,4 do
        table.insert(Beeps, love.audio.newSource("res/sounds/boop_"..i..".wav", "static"))
    end

    function NextQueue()
        MoveQueue = {}
        Presentation = {}
        N = N + 1
        for i=1,N do
            MoveQueue[i] = math.random(4)
            Presentation[i] = MoveQueue[i]
        end
        Timer = -1
        I = 0
    end
    function Restart()
        N = 3
        Score = 0
        W = false
        MouseDown = false
        FadeQueue = {}
        NextQueue()
    end
    Restart()
end

function love.update(dt)
    Timer = Timer + dt
    ::skip::
    if Timer > 1 and I <= 4 then
        if #Presentation == 0 then I = 5 goto skip end
        I = table.remove(Presentation, 1)
        Beeps[I]:play()
        Timer = 0
    end
    for i,f in ipairs(FadeQueue) do
        f.time = f.time - dt
        if f.time < 0 then table.remove(FadeQueue, i) end
    end
end

function love.draw()
    local colors = {
        {love.math.colorFromBytes(239, 245, 66, 255)},
        {love.math.colorFromBytes(66, 87, 245)},
        {love.math.colorFromBytes(245, 87, 66)},
        {love.math.colorFromBytes(119, 255, 115)},
        lost = {love.math.colorFromBytes(255, 0, 0)},
        white = {love.math.colorFromBytes(255, 255, 255)}
    }

    local function pos_y(k)
        if k > 2 then return 1 else return 0 end
    end
    local function pos_x(k)
        --if k % 2 == 0 then return 1 else return 0 end
        --swag
        return bit.band(1,bit.bnot(k % 2))
    end

    for n = 1,4 do
        love.graphics.setColor(colors[n])
        if W then love.graphics.setColor(colors.lost) end

        love.graphics.rectangle("fill", pos_x(n) * 125 + 25, pos_y(n) * 125 + 25, 100, 100)

        if I == n and not W then
            love.graphics.setColor(1, 1, 1, 0.6)
            love.graphics.rectangle("fill", pos_x(n) * 125 + 25, pos_y(n) * 125 + 25, 100, 100)
        elseif W then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", pos_x(n) * 125 + 25, pos_y(n) * 125 + 25, 100, 100)
        end
    end
    for _, v in ipairs(FadeQueue) do
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.rectangle("fill", pos_x(v.thing) * 125 + 25, pos_y(v.thing) * 125 + 25, 100, 100)
    end

    love.graphics.setColor(colors.white)
    love.graphics.printf(""..Score, Fnt, 0, -2, 275, "center")

    if W then
        love.graphics.printf("press 'r' to restart", SFnt, 0, 275 / 2 - 10, 275, "center")
    end
end