function love.load()
    z = 0
end

function love.update()
    z = z + 0.01
end

function love.draw()
    love.graphics.clear(0.08, 0.03, 0.084)
    love.graphics.setBlendMode("add")
    love.graphics.setColor(0.4, 0.5, 0.8, 1)
    for y = 0, love.graphics.getPixelHeight(), 30 do
        for x = 0, love.graphics.getPixelWidth(), 30 do
            n = love.math.noise(x / 100 , y / 100, z)
            r = n * n * 30 + 1
            love.graphics.circle("line", x, y, r)
        end
    end
end