local scene = require "scene"
local bubble = require "bubble"

local function update(self)
    local clicked = love.mouse.isDown(1)
    local x, y = love.mouse.getPosition()

    for i, b in pairs(self.bubbles) do
        b:mouseOn(x, y)
        if clicked then b:click(self) end
        b:update(i, self)
    end

    self.frames = self.frames + 1
end

local function draw(self)
    love.graphics.clear(0.921, 0.931, 0.906)

    for i, b in pairs(self.bubbles) do
        b:draw(self)
    end
end

local function init(self)
    self.frames = 0
    self.bubbles = {}
    for i = 0, bubble.numberOfBubbles do
        self.bubbles[i] = bubble.new(0)
    end
end

local function new()
    local s = scene.new()

    s.init = init
    s.update = update
    s.draw = draw

    s:init()

    return s
end

return {
    new = new,
}
