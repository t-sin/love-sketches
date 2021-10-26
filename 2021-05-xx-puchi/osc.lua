local function oscillate(self)
    local phDiff = self.freq / self.data:getSampleRate() * math.pi
    for i = 0, self.data:getSampleCount() - 1 do
        local v = math.sin(self.ph)
        self.data:setSample(i, v)
        self.ph = self.ph + phDiff
    end
end

local function play(self)
    love.audio.play(self.source)
    self.playing = true
end

local function stop(self)
    self.source:stop()
    self.playing = false
end

local function proc(self)
    if self.playing and not self.source:isPlaying() then
        self:oscillate()
        self:play()
    end
end

local function new()
    local s = {}

    s.data = love.sound.newSoundData(1024, 44100, 16, 1)
    s.source = love.audio.newSource(s.data)
    s.ph = 0
    s.freq = 440
    s.playing = false

    s.oscillate = oscillate
    s.proc = proc
    s.play = play

    s:oscillate()

    return s
end

return {
    new = new,
}
