local flux = require "flux"

local Animation = {}

function Animation.update(dt)
    flux.update(dt)
end

function Animation.flipCard(card, duration)
    card.faceUp = not card.faceUp
end


return Animation