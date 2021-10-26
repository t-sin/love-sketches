local track0 = require "track0"
local track1 = require "track1"
local track2 = require "track2"
local track3 = require "track3"
local track4 = require "track4"
local track5 = require "track5"

function update(self)
    self.p.th = self.p.th + self.p.dth
    self.p.x = math.sin(self.p.th) * self.r + self.c.x
    self.p.y = math.cos(self.p.th) * self.r + self.c.y

    for n = 0, table.getn(self.array) do
        r = self.array[n]
        if not(r.on) and time >= r.start then
            r.x = self.p.x
            r.y = self.p.y
            r.on = true
        end

        if r.on then
            r.r = r.r + r.rd
        end
    end
end

function draw(self)
    love.graphics.setColor(0.1, 0.2, 0.6)
    love.graphics.circle("fill", self.p.x, self.p.y, 6)
    love.graphics.circle("line", self.p.x, self.p.y, 8)

    for n = 0, table.getn(self.array) do
        r = self.array[n]

        if r.on then
            alpha = 1 - (time - r.start)
            if alpha < 0 then alpha = 0 end
            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.circle(self.fill, r.x, r.y, r.r)
        end
    end
end

function newTrackRipples(noteOns, ri)
    local ripple = {}
    ripple.update = update
    ripple.draw = draw
    ripple.array = {}

    ripple.c = {}
    ripple.c.x = love.graphics.getPixelWidth() / 2
    ripple.c.y = love.graphics.getPixelHeight() / 2
    ripple.p = {}
    ripple.p.x = 0
    ripple.p.y = 0
    ripple.p.th = 0
    ripple.p.dth = 0.03
    ripple.r = 250
    ripple.ri = ri
    ripple.fill = "line"

    for n = 0, table.getn(noteOns) do
        ripple.array[n] = {}
        ripple.array[n].on = false
        ripple.array[n].start = noteOns[n]
	ripple.array[n].x = 20000
        ripple.array[n].y = 20000
        ripple.array[n].r = 0
        ripple.array[n].rd = math.random() * math.random() * ripple.ri + ripple.ri / 0.4
    end

    return ripple
end

function love.load()
    time = -0.0001
    frames = 1

    track0 = newTrackRipples(track0.noteOns, 0.61)
    track0.r = 250

    track1 = newTrackRipples(track1.noteOns, 2)
    track1.r = 0

    track2 = newTrackRipples(track2.noteOns, 0.64)
    track2.r = 250
    track2.p.th = math.pi

    track3 = newTrackRipples(track3.noteOns, 1.14)
    track3.p.th = math.pi * 0.5
    track3.r = 400

    track4 = newTrackRipples(track4.noteOns, 1.14)
    track4.p.th = math.pi + math.pi * 0.5
    track4.r = 400

    track5 = newTrackRipples(track5.noteOns, 2.34)
    track5.r = 0
    track5.fill = "fill"

    bgRipple = {}
    for n = 0, 100 do
        bgRipple[n] = {}
        bgRipple[n].on = false
        bgRipple[n].start = 20 + math.random() * 200
        bgRipple[n].x = math.random() * love.graphics.getPixelWidth()
        bgRipple[n].y = math.random() * love.graphics.getPixelWidth()
        bgRipple[n].r = 0
        bgRipple[n].rd = math.random() * math.random() * 0.721 + 0.98
    end

    music = love.audio.newSource("drop.mp3", "stream")
    isPlay = false

    width = 1
end

function love.update(dt)
    if love.keyboard.isDown("a") then
        isPlay = true
        love.audio.play(music)
    end

    for n = 0, table.getn(bgRipple) do
        if not(bgRipple[n].on) and frames > bgRipple[n].start then
            bgRipple[n].x = math.random() * love.graphics.getPixelWidth()
            bgRipple[n].y = math.random() * love.graphics.getPixelWidth()
            bgRipple[n].r = 0
            bgRipple[n].rd = math.random() * math.random() * 0.921 + 0.48
            bgRipple[n].on = true
        end

        if bgRipple[n].on then
            bgRipple[n].r = bgRipple[n].r + bgRipple[n].rd

            if bgRipple[n].r > 60 then
                bgRipple[n].on = false
                bgRipple[n].start = 20 + frames + math.random() * 200
                bgRipple[n].r = 0
            end
        end
    end

    frames = frames + 1

    track0:update()
    track1:update()
    track2:update()
    track3:update()
    track4:update()
    track5:update()

    if not(isPlay) then
        return
    end

    time = time + dt
end

function love.draw()
    love.graphics.clear(0.45, 0.67, 0.8)
    love.graphics.setBlendMode("add")

    love.graphics.setLineWidth(0.4)
    for n = 0, table.getn(bgRipple) do
        alpha = 0.3 - (frames - bgRipple[n].start) / 200
        if alpha < 0 then alpha = 0 end
        love.graphics.setColor(0.9, 0.9, 0.9, alpha)
        love.graphics.circle("line", bgRipple[n].x, bgRipple[n].y, bgRipple[n].r)
    end

    love.graphics.setLineWidth(3)

    track0:draw()
    track1:draw()
    track2:draw()
    track3:draw()
    track4:draw()
    track5:draw()
end
