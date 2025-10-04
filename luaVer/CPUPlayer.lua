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
            if indexOf(Card.values, card.value) > indexOf(Card.values, self.pulledCard.value) then
                discardedCard = card
                self.knownCards[i] = self.pulledCard
                self.hand[i] = self.pulledCard
                break
            end
        end
    end
    GameTable.discard.value, GameTable.discard.suit = discardedCard.value, discardedCard.suit
end

function CPUPlayer:jumpIn(GameTable)
    -- sometimes crashes for some reason, idk
    for i = #self.knownCards, 1, -1 do
        if self.knownCards[i] ~= "?" and self.knownCards[i] ~= nil then
            local card = self.knownCards[i]
            if card.value == GameTable.discard.value then
                GameTable.discard.suit = card.suit
                table.remove(self.hand, i)
                table.remove(self.knownCards, i)
            end
        end
    end
end

function CPUPlayer:playTurn(GameTable)
    -- unfinished stuff: if i swap cpu's card, it doesn't update as a "?"
    -- can't use jack, can't use queen, can't jump in, can't dutch, doesn't know what king of diamonds is
    print("BOT played the turn")
    self.turn = false
    self:pull(GameTable)
end

return CPUPlayer