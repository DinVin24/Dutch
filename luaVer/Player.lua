local Card = require "Card"

local Player = {}
Player.__index = Player
Player.CARDSECONDS = 3


function Player:new(name)
    local self = setmetatable({}, Player)
    self.name = name or "PLAYER"
    self.hand = {}
    self.score = 0
    self.dutch = false
    self.cardTimer = Player.CARDSECONDS
    self.seeCards = 2
    self.seeAnyCard = 0
    self.swap = {false, nil, nil}
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

function Player:updateCards(dt)
    if self.cardTimer >= Player.CARDSECONDS then
        self.cardTimer = Player.CARDSECONDS
        for _, card in ipairs(self.hand) do
            card.faceUp = false
        end
    else
        self.cardTimer = self.cardTimer + dt
    end
end

function Player:drawTips()
    if self.seeCards > 0 then
        love.graphics.print("Choose 2 cards to see!", 50, 300)
    elseif self.jumpingIn then
        love.graphics.print("Woah, you're jumping in. Choose the matching card from your hand", 50, 300)
    elseif self.turn and self.pulledCard==nil then
        love.graphics.print("Pull one card from the deck!", 50, 300)
    elseif self.pulledCard then
        love.graphics.print("Choose one card to replace or click the pile to discard it", 50, 300)
    end
end

function Player:revealCards(player, card)
    if self.seeAnyCard > 0 then
        card.faceUp = true
        player.cardTimer = 0
        self.seeAnyCard = self.seeAnyCard - 1
    end
end

function Player:swapCards(card,players)
    if self.swap[1] == true and self.swap[2] == nil then
        self.swap[2] = card
    elseif self.swap[1] == true and self.swap[3] == nil then
        self.swap[3] = card
        local x, y
        print("gonna swap", self.swap[2].value, self.swap[3].value)
        for i=1, #players do
            if indexOf(players[i].hand,self.swap[2]) then
                x = {i, indexOf(players[i].hand,self.swap[2])}
            end
            if indexOf(players[i].hand,self.swap[3]) then
                y = {i, indexOf(players[i].hand,self.swap[3])}
            end
        end
        players[x[1]].hand[x[2]].value, players[x[1]].hand[x[2]].suit = 
        players[y[1]].hand[y[2]].value, players[y[1]].hand[y[2]].suit 


        self.swap = {false, nil, nil}
    end
end

function Player:checkSpecialCards(card)
    if card.used == false then
        if card.value == "queen" then
            self.seeAnyCard = self.seeAnyCard + 1
        end
        if card.value == "jack" then
            print("tryna swap 'em")
            self.swap = {true}
        end
    end
end

return Player
