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
    -- SE STRICA ANEUMATIA CAND FOLOSESC REGINA PE BOT
    -- cred ca trb sa actualizez fixedX si Y
    flux.to(card, half, { scaleX = 0 })
    :onupdate(function()
        card.x = card.fixedX + (1-card.scaleX) * Card.WIDTH / 2
    end)
    :oncomplete(function()
        card.faceUp = not card.faceUp
        flux.to(card, half, { scaleX = 1 })
        :onupdate(function()
            card.x = card.fixedX + (1-card.scaleX) * Card.WIDTH / 2
        end)
        :oncomplete(function()
            card.animating = false
        end)
    end)
end

function Animation.moveCard(card, targetPos, duration, easing)
    -- targetPos = {x=..., y=...}
    duration = duration or 0.3

    card.animating = true

    flux.to(card, duration, { x = targetPos.x, y = targetPos.y })
        :ease("quadinout")
        :oncomplete(function()
            card.animating = false
        end)
end

return Animation