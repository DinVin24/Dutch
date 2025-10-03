local Card = require "Card"

local Player = {}
Player.__index = Player

function Player:new(name)
    local self = setmetatable({}, Player)
    self.name = name or "PLAYER"
    self.hand = {}
    self.score = 0
    self.dutch = false
    self.cardTimer = 0
    self.seeCards = 2
    self.turn = true
    self.pulledCard = nil
    self.jumpingIn = false
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
    spacing = spacing or 100
    startX = startX or 450 --CHANGE TO PERCENTAGES
    startY = startY or 590 -- CHANGE TO PERCENTAGES
    for i, card in ipairs(self.hand) do
        card:setPosition(startX + (i-1)*spacing, startY)
        card:draw()
    end
end

function Player:getCardAt(x, y)
    for _, card in ipairs(self.hand) do
        if x >= card.x and x <= card.x + Card.WIDTH and
           y >= card.y and y <= card.y + Card.HEIGHT then
            return card
        end
    end
    return nil
end

function Player:updateCards()
    if self.cardTimer <= 0 then
        self.cardTimer = 0
        for _, card in ipairs(self.hand) do
            card.faceUp = false
        end
    else
        self.cardTimer = self.cardTimer - 1
    end
end

return Player
