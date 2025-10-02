_G.love = require("love")

local values = {"ace", "two", "three", "four", "five", "six",
                "seven", "eight", "nine", "ten", "jack",
                "queen", "king"}

local suits = {"heart", "diamond", "club", "spade"}

local Deck = {}
local discard = {value = "king", suit = "diamond"}

for _, value in ipairs(values) do
    for _, suit in ipairs(suits) do
        table.insert(Deck, {
            value = value,
            suit = suit,
        })
    end
end

function shuffle (deck)
    for i = #deck, 2, -1 do
       local j = love.math.random(1, i)
       deck[i], deck[j] = deck[j], deck[i] 
    end
end

shuffle(Deck)

function newPlayer(name)
    local player = {
        name = name or "PLAYER",
        hand = {},
        score = 0,
        dutch = false
    }
    return player
end

function deal(player, deck, n)
    for i = 1, n do
        table.insert(player.hand, table.remove(deck))
    end

end

function showCards(player)
    for i, card in ipairs(player.hand) do
        print(card.value .. " of " .. card.suit)
    end
    print()
end

function indexOf(lista, element)
    for i, v in ipairs(lista) do
        if v == element then
            return i
        end
    end
    return nil
end

function drawCard(card,pozX,pozY)
    local x = indexOf(values, card.value)
    local y = indexOf(suits, card.suit) - 1
    local i = y*14 + x
    love.graphics.draw(cardSprite.tile, cardSprite.quads[i], pozX, pozY)

end

local NrPlayers = 0
local players = {}
table.insert(players, newPlayer("Daniel"))
table.insert(players, newPlayer("Bogdan"))

for i=1, NrPlayers do
    deal(players[i], Deck, 4)
    print(players[i].name)
    showCards(players[i])
end

function love.load()
    cardSprite = {
        tile = love.graphics.newImage("PNG/cardsLarge_tilemap.png"),
        SPRITE_WIDTH = 909,
        SPRITE_HEIGHT = 259,
        CARD_WIDTH = 42,
        CARD_HEIGHT = 60,
        hPadding = 11,
        vPadding = 2,
        quads = {}
    }
    for row = 0, 3 do
        for col = 0, 13 do
            local x = col * (cardSprite.CARD_WIDTH + 2*cardSprite.hPadding +1 ) + cardSprite.hPadding
            local y = row * (cardSprite.CARD_HEIGHT + 2*cardSprite.vPadding + 1) + cardSprite.vPadding

            local quad = love.graphics.newQuad(x,y,cardSprite.CARD_WIDTH,cardSprite.CARD_HEIGHT,cardSprite.SPRITE_WIDTH,cardSprite.SPRITE_HEIGHT)
            table.insert(cardSprite.quads,quad)
        end
    end
    
end

function love.update(dt)
    
end

function love.draw()
   --for i, card in ipairs(Deck) do
   --     love.graphics.print(card.value .. " of " .. card.suit, 20, i*15)
   --end
   for i, card in ipairs(Deck) do
        local x = (i-1) % 13
        local y = math.floor((i-1) / 13)
        print(x, y)
        drawCard(Deck[i], 50 * x, 100 * y)
   end


end

