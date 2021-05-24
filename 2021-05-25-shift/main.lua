function love.load()
    frames = 0
    pos = {}
    num = 2000
    for n = 0, num do
        pos[n] = {}
	pos[n].w = math.random() * math.random() * math.random() * 100 + 200
        pos[n].h = math.random() * math.random() * math.random() * 100 + 200
        pos[n].angle = math.random() * 3.141592
    end
end

function love.update()
    frames = frames + 1

    if frames % 2 == 0 then
        for n = 0, num do
            pos[n] = {}
            pos[n].w = math.random() * math.random() * math.random() * 100 + 200
	    pos[n].h = math.random() * math.random() * math.random() * 100 + 200
            pos[n].angle = math.random() * 3.141592
        end
    end
end

function love.draw()
    love.graphics.setBlendMode("add")
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(0.1, 0.4, 0.8, 0.01)
    x = love.graphics.getPixelWidth() / 2
    y = love.graphics.getPixelHeight() / 2

    for n = 0, num do
        love.graphics.push()
	love.graphics.translate(x, y)
        love.graphics.rotate(pos[n].angle)
        love.graphics.ellipse("line", 0, 0, pos[n].w, pos[n].h)
        love.graphics.pop()
    end
end
