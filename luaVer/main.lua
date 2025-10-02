_G.love = require("love")
Card = require "Card"
Player = require "Player"
Functions = require "Functions"

local players = {}
local Deck = {}


function love.load()
    Card.loadSpriteSheet("PNG/cardsLarge_tilemap.png")

    for _, value in ipairs(Card.values) do
        for _, suit in ipairs(Card.suits) do
            table.insert(Deck, Card:new(value, suit))
        end
    end

    shuffle(Deck)

    table.insert(players, Player:new("Daniel"))
    table.insert(players, Player:new("Bogdan"))

    for _, p in ipairs(players) do
        p:deal(Deck, 4)
        p:calculateScore()
        p:showHand()
    end
    
end

function love.update(dt)
    
end

function love.draw()
    drawDeck(Deck)
    players[1]:drawHand()

end


--draw all cards:
--   for i, card in ipairs(Deck) do
--        local x = (i-1) % 13
--        local y = math.floor((i-1) / 13)
--        print(x, y)
--        drawCard(Deck[i], 50 * x, 100 * y)
--   end