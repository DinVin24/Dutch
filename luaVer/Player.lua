local Card = require "Card"

local Player = {}
Player.__index = Player

function Player:new(name)
    local self = setmetatable({}, Player)
    self.name = name or "PLAYER"
    self.hand = {}
    self.score = 0
    self.dutch = false
    return self
end

function Player:deal(deck, n)
    for i = 1, n do
        table.insert(self.hand, table.remove(deck))
    end
end

function Player:calculateScore()
    self.score = 0
    for _, card in ipairs(self.hand) do
        if not (card.value == "king" and card.suit == "diamond") then
            self.score = self.score + indexOf(Card.values, card.value)
        end
    end
end

function Player:showHand()
    print(self.name .. "'s hand:")
    for _, card in ipairs(self.hand) do
        print(card.value .. " of " .. card.suit)
    end
    print("Score: " .. self.score)
    print()
end

function Player:drawHand(startX, startY, spacing)
    spacing = spacing or 50
    startX = startX or 570
    startY = startY or 600
    for i, card in ipairs(self.hand) do
        card:setPosition(startX + (i-1)*spacing, startY)
        card.faceUp = false
        card:draw()
    end
end

return Player
