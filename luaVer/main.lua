_G.love = require("love")
Card = require "Card"
Player = require "Player"
Functions = require "Functions"

local players = {}
local GameTable = {
    Deck = {},
    discard = Card:new("king", "diamond", 640, 360, true),
    pulled = nil
}


function love.mousepressed(x, y, button)
    handleMousePressed(x, y, button, players[1], GameTable)
end

function love.load()
    Card.loadSpriteSheet("PNG/cardsLarge_tilemap.png")

    for _, value in ipairs(Card.values) do
        for _, suit in ipairs(Card.suits) do
            table.insert(GameTable.Deck, Card:new(value, suit))
        end
    end

    shuffle(GameTable.Deck)

    table.insert(players, Player:new("Daniel"))
    --table.insert(players, Player:new("Bogdan"))

    for _, p in ipairs(players) do
        p:deal(GameTable.Deck, 4)
        p:calculateScore()
        p:showHand()
    end
    
end

function love.update(dt)
    players[1]:updateCards()
    GameTable.pulled = players[1].pulledCard
end

function love.draw()
    drawDeck(GameTable.Deck)
    players[1]:drawHand()
    GameTable.discard:draw()
    if GameTable.pulled then
        GameTable.pulled:draw(640,500)
    end
end

--draw all cards:
--   for i, card in ipairs(Deck) do
--        local x = (i-1) % 13
--        local y = math.floor((i-1) / 13)
--        print(x, y)
--        drawCard(Deck[i], 50 * x, 100 * y)
--   end