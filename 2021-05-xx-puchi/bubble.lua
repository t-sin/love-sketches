local numberOfBubbles = 150

local BUBBLE_ENABLED = "enabled"
local BUBBLE_DISABLED = "disabled"
local BUBBLE_SELECTED = "selected"
local BUBBLE_VANISHING = "vanishing"

local function draw(self, scene)
    if self.s == BUBBLE_ENABLED then
        love.graphics.setLineWidth(2)

        if self.on then
            love.graphics.setColor(0.4, 0.52, 0.681, 0.2)
            love.graphics.circle("fill", self.x, self.y, self.r)
        end

        local a = 1
        local f = (scene.frames - self.f)
        local m = 20
        if f < m then
            local t = m - f
            a = a - t * t / 20
        end

        love.graphics.setColor(0.4, 0.52, 0.681, a)
        love.graphics.circle("line", self.x, self.y, self.r)

    elseif self.s == BUBBLE_SELECTED then
        love.graphics.setLineWidth(2)

        if self.on then
            love.graphics.setColor(0.891, 0.52, 0.481, 0.2)
            love.graphics.circle("fill", self.x, self.y, self.r)
        end

        love.graphics.setColor(0.891, 0.52, 0.481)
        love.graphics.circle("line", self.x, self.y, self.r)

    elseif self.s == BUBBLE_VANISHING then
        local f = (scene.frames - self.f) / 20
        local a = 0.4 - f * f
        love.graphics.setLineWidth(1)
        love.graphics.setColor(0.5, 0.62, 0.831, a)
        love.graphics.circle("line", self.x, self.y, self.r)
    end
end

local function vanish(self, scene)
    self.s = BUBBLE_VANISHING
    self.f = scene.frames
end

local function select(self, scene)
    self.s = BUBBLE_SELECTED
    self.f = scene.frames
end

local function disable(self, scene)
    self.s = BUBBLE_DISABLED
    self.f = math.random() * 110 + 30
end

local function d(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return math.sqrt(dx * dx + dy * dy)
end

local function detectCollision(self, scene)
    for j, b in pairs(scene.bubbles) do
        if b.s ~= BUBBLE_ENABLED then
            goto continue_b
        end
        if self == b then
            goto continue_b
        end

        if d(self, b) < self.r + b.r then
            self:vanish(scene)
            b:vanish(scene)
            return
        end

        ::continue_b::
    end
end

local function mouseOn(self, x, y)
    mouse = { x = x, y = y }
    self.on = d(mouse, self) < self.r
end

local function click(self, scene)
    if self.on and self.s == BUBBLE_ENABLED then
        self:select(scene)
    end
end

local function reset(bubble, frames)
    local ix = love.math.random() * love.graphics.getPixelWidth()
    local iy = love.math.random() * love.graphics.getPixelHeight()
    local ir = love.math.random() * 10 + 5

    bubble.x = ix
    bubble.y = iy
    bubble.r = ir
    bubble.s = BUBBLE_ENABLED
    bubble.f = frames
    bubble.on = false    
end

local function update(self, i, scene)
    local f = scene.frames - self.f

    if self.s == BUBBLE_ENABLED then
        self.r = self.r + 0.08 + f * f / 22000
        self:detectCollision(scene)

    elseif self.s == BUBBLE_VANISHING then
        self.r = self.r + 0.1 + f * f / 80
        if f > 20 then
            self:disable(scene)
        end

    elseif self.s == BUBBLE_SELECTED then
        self.r = self.r + 0.1 + f * f / 80
        if f > 20 then
            self:disable(scene)
        end

    elseif self.s == BUBBLE_DISABLED then
        self.f = self.f - 1
        if self.f < 0 then
            reset(scene.bubbles[i], scene.frames)
        end
    end
end

local function new(frames)
    local b = {}
    reset(b, frames)

    b.draw = draw
    b.vanish = vanish
    b.disable = disable
    b.select = select

    b.detectCollision = detectCollision
    b.mouseOn = mouseOn
    b.click = click
    b.update = update

    return b
end

return {
    new = new,
    numberOfBubbles = numberOfBubbles,
}
