local function update(self)
end

local function draw(self)
end

local function new()
    local scene = {
        update = update,
        draw = draw,
    }

    return scene
end

return {
    new = new,
}
