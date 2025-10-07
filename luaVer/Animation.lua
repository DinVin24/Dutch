local flux = require "flux"

local Animation = {}

function Animation.update(dt)
    flux.update(dt)
end

function Animation.flipCard(card, duration)
    duration = duration or 0.4
    flux.to(card, duration / 2, { scaleX = 0 })
        :ease("quadout")
        :oncomplete(function()
            card.faceUp = not card.faceUp
            flux.to(card, duration / 2, { scaleX = 2 }):ease("quadin")
        end)
end


return Animation