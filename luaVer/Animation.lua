local flux = require "flux"

local Animation = {}

function Animation.update(dt)
    flux.update(dt)
end

function Animation.flipCard(card, duration)
    duration = duration or 0.3
    if card.animating then return end
    card.animating = true
    card.scaleX = card.scaleX or 1

    local half = duration / 2

    -- Shrink X to 0
    flux.to(card, half, { scaleX = 0 })
    :onupdate(function()
        card.x = card.fixedX + (1-card.scaleX) * Card.WIDTH / 2
    end)
    :oncomplete(function()
        -- swap face
        card.faceUp = not card.faceUp
        -- grow X back to 1
        flux.to(card, half, { scaleX = 1 })
        :onupdate(function()
            card.x = card.fixedX + (1-card.scaleX) * Card.WIDTH / 2
        end)
        :oncomplete(function()
            card.animating = false
        end)
    end)
end


return Animation