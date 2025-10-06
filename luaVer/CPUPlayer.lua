local Card = require "Card"
local Player = require "Player"

local CPUPlayer = setmetatable({}, {__index = Player})
CPUPlayer.__index = CPUPlayer

function CPUPlayer:new(name)
    local self = setmetatable(Player:new(name or "CPU"), CPUPlayer)
    self.isBot = true
    self.seeCards = 0
    self.knownCards = {"?", "?", "?", "?"}
    return self
end

function CPUPlayer:learnCards()
    self.knownCards[1],self.knownCards[2] = self.hand[1], self.hand[2]
end

function CPUPlayer:pull(GameTable)
    local discardedCard = nil
    self.pulledCard = table.remove(GameTable.Deck)
    if self.knownCards[3] == "?" then
        discardedCard = self.hand[3]
        self.knownCards[3] = self.pulledCard
        self.hand[3] = self.pulledCard
    elseif self.knownCards[4] == "?" then
        discardedCard = self.hand[4]
        self.knownCards[4] = self.pulledCard
        self.hand[4] = self.pulledCard
    else
        discardedCard = self.pulledCard
        for i, card in ipairs(self.knownCards) do
            if card ~= "?" and indexOf(Card.values, card.value) > indexOf(Card.values, self.pulledCard.value) 
               and not (card.value == "king" and card.suit == "diamond") then
                -- 33: CRASH-> attempt to compare number with nil SHOULD BE FIXED NOW
                discardedCard = card
                self.knownCards[i] = self.pulledCard
                self.hand[i] = self.pulledCard
                print("CPU pulled", self.pulledCard.value, self.pulledCard.suit, "and discarded", discardedCard.value, discardedCard.suit) --DEBUG
                break
            end
        end
    end
    GameTable.discard.value, GameTable.discard.suit = discardedCard.value, discardedCard.suit
    if discardedCard.value == "queen" then
        self:useQueen()
    elseif discardedCard.value == "jack" then
        self:useJack()
    end
end

function CPUPlayer:calculateKnownScore()
    local score = 0
    for i = 1, #self.knownCards do
        if self.knownCards[i] == "?" then -- if it doesn't know all its cards
            score = 99
            break
        end
        
        if not (self.knownCards[i].value == "king" and self.knownCards[i].value == "diamond") then
           score = score + indexOf(Card.values, self.knownCards[i].value) 
        end
    end
    print(score) --DEBUG
    return score
end

function CPUPlayer:callDutch()
    if self.dutch < 1 then
        if self:calculateKnownScore() <= 7 then
            self.dutch = self.dutch + 1
            print("CPU called Dutch")
        end
    end
end

function CPUPlayer:jumpIn(GameTable)
    -- sometimes crashes for some reason, idk
    for i = #self.knownCards, 1, -1 do
        if self.knownCards[i] ~= "?" and self.knownCards[i] ~= nil
           and not (self.knownCards[i].value == "king" and self.knownCards[i].suit == "diamond") then
            local card = self.knownCards[i]
            if card.value == GameTable.discard.value then  --if cards match
                GameTable.discard.suit = card.suit
                print("CPU jumped in with", card.value, card.suit) --DEBUG
                table.remove(self.hand, i)
                table.remove(self.knownCards, i)
                if card.value == "queen" then
                    self:useQueen()
                elseif card.value == "jack" then
                    self:useJack()
                end
            end
        end
    end
end

function CPUPlayer:useQueen()
    for i = 1, #self.knownCards do
        if self.knownCards[i] == "?" then
            self.knownCards[i] = self.hand[i]
            print("CPU used queen to learn", self.hand[i].value, self.hand[i].suit) --DEBUG
            break
        end
    end
    --TODO: upgrade to choose player's card
end

function CPUPlayer:useJack()
    -- if it has a card greater than 7, it will swap with one of the player's cards I guess
    -- if all cards are <= 7, it will just swap 2 random player's cards

    -- later on: what if the player only has 1 card and the CPU has good cards.
    -- counter a player's jack so the known gets recovered.
    -- would work great if he keeps track of the player's cards
    -- or based by the player's confidence. example: player calls dutch, CPU should go for a swap
end

function CPUPlayer:thinking()
    -- i'll work on this later. it's for more complex plays
    -- add logic to how valuable a card is.
end

function CPUPlayer:playTurn(GameTable)
    -- unfinished stuff: if i swap cpu's card, it doesn't update as a "?"
    -- add all the functions here so i can call only this in love.update
    print("BOT played the turn")
    self.turn = false
    self:pull(GameTable)
    self:callDutch()
end

return CPUPlayer