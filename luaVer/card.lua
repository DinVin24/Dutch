local Card = {}
Card.__index = Card

Card.values = {"ace", "two", "three", "four", "five", "six",
                "seven", "eight", "nine", "ten", "jack",
                "queen", "king"}

Card.suits = {"heart", "diamond", "club", "spade"}

Card.sprite = nil
Card.SPRITE_WIDTH = 1818 --909
Card.SPRITE_HEIGHT = 518 --259
Card.WIDTH = 84 --42 
Card.HEIGHT = 120 --60
Card.hPadding = 22 --11
Card.vPadding = 4 --2
Card.quads = {}

function Card.loadSpriteSheet(imagePath)
    Card.sprite = love.graphics.newImage(imagePath)
    for row = 0, 3 do
        for col = 0, 13 do
            local x = col * (Card.WIDTH + 2*Card.hPadding + 2) + Card.hPadding
            local y = row * (Card.HEIGHT + 2*Card.vPadding + 2) + Card.vPadding

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
    self.fixedX = x or 0
    self.fixedY = y or 0
    self.width = Card.WIDTH
    self.height = Card.HEIGHT
    self.scaleX = 1
    self.scaleY = 1
    self.used = false
    self.animating = false
    return self
end

function Card:getPos()
    return self.x,self.y
end

function Card:setPosition(x, y)
    self.x = x
    self.y = y
    self.fixedX = x
    self.fixedY = y
end

function Card:draw(pozX,pozY,scaleX, scaleY)
    self.x = pozX or self.x
    self.y = pozY or self.y

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

    if self.animating then
        love.graphics.draw(Card.sprite,Card.quads[quadIndex],self.x,self.y,0,self.scaleX,self.scaleY)
    else
        love.graphics.draw(Card.sprite,Card.quads[quadIndex],self.fixedX,self.fixedY,0)
    end
end

return Card