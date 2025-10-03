local Card = {}
Card.__index = Card

Card.values = {"ace", "two", "three", "four", "five", "six",
                "seven", "eight", "nine", "ten", "jack",
                "queen", "king"}

Card.suits = {"heart", "diamond", "club", "spade"}

Card.sprite = nil
Card.SPRITE_WIDTH = 909
Card.SPRITE_HEIGHT = 259
Card.WIDTH = 42
Card.HEIGHT = 60
Card.hPadding = 11
Card.vPadding = 2
Card.quads = {}

function Card.loadSpriteSheet(imagePath)
    Card.sprite = love.graphics.newImage(imagePath)
    for row = 0, 3 do
        for col = 0, 13 do
            local x = col * (Card.WIDTH + 2*Card.hPadding + 1) + Card.hPadding
            local y = row * (Card.HEIGHT + 2*Card.vPadding + 1) + Card.vPadding

            local quad = love.graphics.newQuad(x, y, Card.WIDTH, Card.HEIGHT, Card.SPRITE_WIDTH, Card.SPRITE_HEIGHT)
            table.insert(Card.quads, quad)
        end
    end
end

function Card:new(value, suit, x, y, faceUp)
    local self = setmetatable({}, Card)
    self.value = value
    self.suit = suit
    self.faceUp = faceUp or false
    self.x = x or 0
    self.y = y or 0
    self.used = false
    return self
end

function Card:getPos()
    return self.x,self.y
end

function Card:setPosition(x, y)
    self.x = x
    self.y = y
end

function Card:draw(pozX,pozY,scale)
    self.x = pozX or self.x
    self.y = pozY or self.y
    scale = scale or 2
    if not Card.sprite then
        error("Card sprite not loaded. Call Card.loadSpriteSheet() first!")
    end

    local xIndex = nil
    local yIndex = nil
    for i, v in ipairs(Card.values) do
        if v == self.value then xIndex = i end
    end
    for i, s in ipairs(Card.suits) do
        if s == self.suit then yIndex = i-1 end
    end

    local quadIndex = yIndex * 14 + xIndex
    if not self.faceUp then
        quadIndex = 28
    end

    love.graphics.draw(Card.sprite, Card.quads[quadIndex], self.x, self.y, 0, scale, scale)
end

return Card