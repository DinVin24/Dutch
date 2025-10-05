_G.love = require("love")
Card = require "Card"
Player = require "Player"
Functions = require "Functions"
CPUPlayer = require "CPUPlayer"

local background = love.graphics.newImage("PNG/back.jpg")
local players = {}
local GameTable = {
    Deck = {},
    discard = Card:new(nil, nil, 598, 300, true),
    pulled = nil,
    over = false,
    turn = nil
}

function love.mousepressed(x, y, button)
    handleMousePressed(x, y, button, players, GameTable)
end

function love.keypressed(key)
    handleKeyPress(key, GameTable.turn, players)
end

function love.load()
    love.graphics.setBackgroundColor( 0.5, 0, 0.52 )
    Card.loadSpriteSheet("PNG/custom.png")

    Card.WIDTH = math.floor(Card.WIDTH*2)
    Card.HEIGHT = math.floor(Card.HEIGHT*2)

    for _, value in ipairs(Card.values) do
        for _, suit in ipairs(Card.suits) do
            table.insert(GameTable.Deck, Card:new(value, suit))
        end
    end

    shuffle(GameTable.Deck)

    table.insert(players, Player:new("Emi"))
    table.insert(players, CPUPlayer:new())
    for _, p in ipairs(players) do
        p:deal(GameTable.Deck, 4)
        p:calculateScore()
        if p.isBot then
            p:learnCards()
        end
        p:showHand()--DEBUG
    end
    GameTable.turn = players[1]
    players[1].turn = true
end

function love.update(dt)
    if not GameTable.over then
        for _, p in ipairs(players) do
            p:updateCards(dt)
        end
        if GameTable.turn.turn == false then
            GameTable.turn.pulled = false
            if indexOf(players, GameTable.turn) == #players then
                GameTable.turn = players[1]
            else
                GameTable.turn = players[indexOf(players, GameTable.turn)+1]
            end
            GameTable.turn.turn = true
        end
        if GameTable.turn.isBot then
            GameTable.turn:playTurn(GameTable)
        end

        players[2]:jumpIn(GameTable)

        GameTable.turn:checkSpecialCards(GameTable.discard)
        GameTable.discard.used = true -- should be updated in the above function...
        GameTable.pulled = GameTable.turn.pulledCard
        if GameTable.turn.dutch==1 or #GameTable.turn.hand == 0 then
            --happens too fast, i need to play one more round before game ends
            GameTable.over = true
            print("GAME OVER!")
        end
    else
        for _, p in ipairs(players) do
            for _, card in ipairs(p.hand) do
                card.faceUp = true
            end
        end
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    drawDeck(GameTable.Deck)
    players[1]:drawHand()
    players[2]:drawHand(450, 20)
    --players[3]:drawHand(0,360)
    --players[4]:drawHand(900,360)
    if GameTable.discard.value then
        GameTable.discard:draw()
    end
    if GameTable.pulled then
        GameTable.pulled:draw(700,450)
    end
    GameTable.turn:drawTips()
    if GameTable.over then
        love.graphics.print("GAME OVER!", 400, 260)
        if players[1]:calculateScore() < players[2]:calculateScore() then
            love.graphics.print("P1 WON", 400, 280)
        else
            love.graphics.print("CPU WON", 400, 280)
        end
    end
end

--draw all cards:
--   for i, card in ipairs(Deck) do
--        local x = (i-1) % 13
--        local y = math.floor((i-1) / 13)
--        print(x, y)
--        drawCard(Deck[i], 50 * x, 100 * y)
--   end