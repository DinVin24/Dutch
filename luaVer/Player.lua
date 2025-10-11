local Card = require "Card"
--local Animation = require "Animation"


local Player = {}
Player.__index = Player
Player.CARDSECONDS = 3
local p1 = {x=450, y=590}
local p2 = {x=450, y=20}
local p3 = {x=0, y=360}
local p4 = {x=900, y=360}
local positions = {p1, p2, p3, p4}

function Player:new(name, index)
    local self = setmetatable({}, Player)
    self.x = positions[index].x
    self.y = positions[index].y
    self.name = name or "PLAYER"
    self.isBot = false
    self.hand = {}
    self.score = 0
    self.dutch = -1
    self.cardTimer = 0
    self.seeCards = 2
    self.seeAnyCard = 0
    self.swap = {false, nil, nil} -- first value is if swapping, second and third are the cards to swap
    self.turn = false
    self.pulledCard = nil
    self.pulled = false
    self.jumpingIn = false
    return self
end

function Player:deal(deck, n)
    spacing = 100
    for i = 1, n do
        table.insert(self.hand, table.remove(deck))
        self.hand[#self.hand].x = self.x + (#self.hand-1) * spacing
        self.hand[#self.hand].y = self.y

        self.hand[#self.hand].fixedX = self.hand[#self.hand].x
        self.hand[#self.hand].fixedY = self.hand[#self.hand].y
    end
end

function Player:calculateScore()
    self.score = 0
    for _, card in ipairs(self.hand) do
        if not (card.value == "king" and card.suit == "diamond") then
            self.score = self.score + indexOf(Card.values, card.value)
        end
    end
    return self.score
end

function Player:showHand()
    print(self.name .. "'s hand:")
    for _, card in ipairs(self.hand) do
        print(card.value .. " of " .. card.suit)
    end
    print("Score: " .. self.score)
    print()
end

function Player:getCardAt(x, y)
    for _, card in ipairs(self.hand) do
        if x >= card.fixedX and x <= card.fixedX + Card.WIDTH and
           y >= card.fixedY and y <= card.fixedY + Card.HEIGHT then
            print(indexOf(self.hand, card))
            print(x,y)
            return card
        end
    end
    return nil
end

function Player:drawTips()
    if self.jumpingIn then
        love.graphics.print("Woah, you're jumping in. Choose the matching card from your hand", 50, 300)
    elseif self.seeCards > 0  then
        love.graphics.print("Choose 2 cards to see!", 50, 300)
    elseif self.turn and self.pulledCard==nil then
        love.graphics.print("Pull one card from the deck!", 50, 300)
    elseif self.pulledCard then
        love.graphics.print("Choose one card to replace or click the pile to discard it", 50, 300)
    end
end

function Player:revealCards(player, card)    
    if self.seeAnyCard > 0 then
        Animation.flipCard(card)  -- ANIMATION TEST
        player.cardTimer = 0
        self.seeAnyCard = self.seeAnyCard - 1
    end
end

function Player:learnCards(clickedCard)
    if self.seeCards > 0 or self.seeAnyCard > 0 then
        if clickedCard.faceUp == false then
            if self.seeCards <= 0 then
                self.seeAnyCard = self.seeAnyCard - 1
            else
                self.seeCards = self.seeCards - 1
            end
        end
        
        Animation.flipCard(clickedCard)

        if self.cardTimer >= Player.CARDSECONDS  then
            self.cardTimer = 0
        end
        return clickedCard
    end
end

function Player:replaceCard(clickedCard, GameTable)
    if self.pulledCard then -- replacing a card
        GameTable.discard.value, GameTable.discard.suit = clickedCard.value, clickedCard.suit
        GameTable.discard.used = false

        GameTable.discard.x, GameTable.discard.y = clickedCard.x, clickedCard.y--animation
        GameTable.discard.faceUp = false
        Animation.flipCard(GameTable.discard)
        Animation.moveCard(GameTable.discard, {x = GameTable.discard.fixedX, y = GameTable.discard.fixedY})

        clickedCard.value, clickedCard.suit = self.pulledCard.value, self.pulledCard.suit

        clickedCard.x, clickedCard.y = self.pulledCard.x, self.pulledCard.y
        Animation.moveCard(clickedCard, {x = clickedCard.fixedX, y = clickedCard.fixedY})

        self.pulledCard = nil
        self.pulled = true
        return clickedCard
    end
end

function Player:jumpIn(clickedCard, GameTable)
    if self.jumpingIn then
        if GameTable.discard.value == clickedCard.value then
            GameTable.discard.value, GameTable.discard.suit = clickedCard.value, clickedCard.suit

            GameTable.discard.x, GameTable.discard.y = clickedCard.x, clickedCard.y
            Animation.moveCard(GameTable.discard, {x = GameTable.discard.fixedX, y = GameTable.discard.fixedY})

            GameTable.discard.used = false
            table.remove(self.hand, indexOf(self.hand, clickedCard))
        else
            Animation.flipCard(clickedCard)
            self:deal(GameTable.Deck, 1)
        end
        self.jumpingIn = false
    end
end

function Player:discardCard(discard)
    if self.pulledCard then
        discard.value, discard.suit = self.pulledCard.value, self.pulledCard.suit
        
        discard.x, discard.y = self.pulledCard.x, self.pulledCard.y
        Animation.moveCard(discard,{x = discard.fixedX,y = discard.fixedY})
        
        discard.used = false
        self.pulledCard = nil
        self.pulled = true
        return discard
    end
end

function Player:swapCards(card,players)
    -- think of a better way to do this 
    if self.swap[1] == true and self.swap[2] == nil then
        self.swap[2] = card
    elseif self.swap[1] == true and self.swap[3] == nil then
        self.swap[3] = card
        local x, y -- = {playerIndex, cardIndex }
        print("gonna swap", self.swap[2].value, self.swap[3].value)
        for i=1, #players do
            if indexOf(players[i].hand,self.swap[2]) then
                x = {i, indexOf(players[i].hand,self.swap[2])}
            end
            if indexOf(players[i].hand,self.swap[3]) then
                y = {i, indexOf(players[i].hand,self.swap[3])}
            end
        end
        players[x[1]].hand[x[2]], players[y[1]].hand[y[2]] = players[y[1]].hand[y[2]], players[x[1]].hand[x[2]]
        if players[x[1]].isBot and players[x[1]] == players[y[1]] then
            local temp = players[x[1]].knownCards[x[2]]
            players[x[1]].knownCards[x[2]] = players[y[1]].knownCards[y[2]]
            players[y[1]].knownCards[y[2]] = temp
        else
            if players[x[1]].isBot then
                players[x[1]].knownCards[x[2]] = "?"
            end
            if players[y[1]].isBot then
                players[y[1]].knownCards[y[2]] = "?"
            end
        end
        self.swap = {false, nil, nil}
    end
end

function Player:checkSpecialCards(card)
    if not card then return end --safety check
    if card.used == false then
        if card.value == "queen" then
            self.seeAnyCard = self.seeAnyCard + 1
        end
        if card.value == "jack" then
            print("tryna swap 'em")
            self.swap = {true, nil, nil}
        end
    end
end

function Player:checkDutch()
    if self.turn and self.dutch == -1 then
        self.dutch = 0
        self.turn = false
    elseif self.turn and self.dutch == 0 then
        self.dutch = 1
    end
end

function Player:updateCards(dt)
    if self.cardTimer >= Player.CARDSECONDS then
        self.cardTimer = 0
        for _, card in ipairs(self.hand) do
            if card.faceUp then Animation.flipCard(card) end
        end
    else
        self.cardTimer = self.cardTimer + dt
    end
    self:recalculatePositions()
end

function Player:recalculatePositions()
    for i, card in ipairs(self.hand) do

        if card.fixedX ~= self.x + (i-1) * 100 or card.fixedY ~= self.y then
            Animation.moveCard(card, {x = self.x + (i-1)*100, y = self.y})
        end

        card.fixedX = self.x + (i-1) * 100
        card.fixedY = self.y
        if card.animating == false then
            card.x = card.fixedX
            card.y = card.fixedY
        end
    end
end

function Player:endTurn()
    --put here all the variables that need to reset
    --functions that need to be called
end

return Player
