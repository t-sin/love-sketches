function love.load()
    frames = 1
    pos = {}
    num = 2000

    for n = 0, num do
        pos[n] = {}
	pos[n].x = math.random() * (love.graphics.getPixelWidth() + 100)
        pos[n].y = math.random() * (love.graphics.getPixelHeight() + 100)
        pos[n].r = math.random() * 50 + 5
        pos[n].rd = math.random() * math.random() * 0.821 + 0.2535
    end

    music = love.audio.newSource("hi.mp3", "stream")
    isPlay = false
end

function love.update()
    if love.keyboard.isDown("a") then
        isPlay = true
        love.audio.play(music)
    end

    width = 10
    alpha = 0.01
    if not(isPlay) then
        return
    end

    frames = frames + 1
    maxf = 60 * 60 * 5.2
    th = frames / (10 * 60)

    width = maxf / (frames * 40) + 4 * (math.sin(th * 10.32) + 1)
    alpha = (math.sin(th / 1.23) + 1) / 12.2123 + 0.02
    ratio = (maxf / (frames * 111))
    if ratio < 1 then
        ratio = 1
    end

    for n = 0, num do
        pos[n].r = pos[n].r + pos[n].rd * ratio
    end
end

function love.draw()
    love.graphics.setBlendMode("subtract")
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0.8, 0.1, 0.3, alpha)
    love.graphics.setLineWidth(width)

    for n = 0, num do
        love.graphics.circle("line", pos[n].x, pos[n].y, pos[n].r, pos[n].r)
    end
end
