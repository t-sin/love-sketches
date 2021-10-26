local game_scene = require "game_scene"
local oscillator = require "osc"

local scene = nil

function love.load()
    osc = oscillator.new()
    love.audio.play(osc.source)

    scene = game_scene.new()
end

function love.update()
    osc:proc()

    scene:update()
end

function love.draw()
    scene:draw()
end
