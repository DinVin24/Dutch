function shuffle (deck)
    for i = #deck, 2, -1 do
       local j = love.math.random(1, i)
       deck[i], deck[j] = deck[j], deck[i] 
    end
end

function indexOf(lista, element)
    for i, v in ipairs(lista) do
        if v == element then
            return i
        end
    end
    return nil
end


function drawDeck(Deck)
    for i, card in ipairs(Deck) do
        Deck[i]:draw(800 - i*0.2, 310+i*0.1)-- MAKE THESE PIXELS SCALABLE
    end
end

function clickedOwnCard(x,y,Players,GameTable)
    -- i really don't like how i made this function...
    player = GameTable.turn
    local clickedCard = player:getCardAt(x, y)
    if clickedCard then
        if player.seeCards > 0 or player.seeAnyCard > 0 then
            if clickedCard.faceUp == false then
                if player.seeCards <= 0 then
                    player.seeAnyCard = player.seeAnyCard - 1
                else
                    player.seeCards = player.seeCards - 1
                end
            end
            clickedCard.faceUp = true
            if player.cardTimer >= Player.CARDSECONDS  then
                player.cardTimer = 0
            end
            return clickedCard
        end
        if player.pulledCard then
            GameTable.discard.value, GameTable.discard.suit = clickedCard.value, clickedCard.suit
            GameTable.discard.used = false
            --player.discardVal = GameTable.discard.value
            --print("you discarded a ", player.discardVal)
            clickedCard.value, clickedCard.suit = player.pulledCard.value, player.pulledCard.suit
            player.pulledCard = nil
            return clickedCard
        end
        if player.jumpingIn then
            if GameTable.discard.value == clickedCard.value then
                GameTable.discard.value, GameTable.discard.suit = clickedCard.value, clickedCard.suit
                GameTable.discard.used = false
                --player.discardVal = GameTable.discard.value
                --print("you discarded a ", player.discardVal)
                table.remove(player.hand, indexOf(player.hand, clickedCard))
            else
                player:deal(GameTable.Deck, 1)
            end
            player.jumpingIn = false

        end
        player:swapCards(clickedCard, Players)
        return clickedCard
    end
    return nil
end

function clickedOtherCard(x,y,players,GameTable) 
    local clickedCard = nil
    local p = nil
    for i, player in ipairs(players) do
        if i ~= 1 then
            if player:getCardAt(x,y) then
                clickedCard = player:getCardAt(x,y)
                p = player
            end
        end
    end

    if clickedCard then
        GameTable.turn:revealCards(p, clickedCard)
        GameTable.turn:swapCards(clickedCard, players)
    end

end

function clickedDeck(x,y,player,deck)
    local deckX, deckY, deckW, deckH = deck[1].x, deck[1].y, Card.WIDTH, Card.HEIGHT
    if x > deckX and x < deckX+deckW and y>deckY and y < deckY+deckH and player.turn and player.pulledCard == nil then
        player.pulledCard = table.remove(deck)
        player.pulledCard.faceUp = true
    end
    return nil
end

function clickedPile(x,y,player,discard)
    if x > discard.x and x < discard.x + Card.WIDTH and y > discard.y and y < discard.y + Card.HEIGHT then
        if player.pulledCard then
            discard.value, discard.suit = player.pulledCard.value, player.pulledCard.suit
            discard.used = false
            --player.discardVal = discard.value
            --print("you discarded a ", player.discardVal)
            player.pulledCard = nil
            return discard
        end
    end
    return nil
end

function handleMousePressed(x, y, button, Players, GameTable)
    if button == 1 then
        clickedOwnCard(x,y,Players,GameTable)
        
        clickedOtherCard(x,y,Players,GameTable)

        clickedDeck(x,y,GameTable.turn,GameTable.Deck)

        clickedPile(x,y,GameTable.turn,GameTable.discard)

    end
    return nil
end

function handleKeyPress(key, player)
    if key == "space" then --jumping in
        player.jumpingIn = true
    end
    if key == "d" then
        player:checkDutch()
    end
    if key == "c" then -- idk make a better check to finish one's turn
        player.turn = false
    end
    if key == "l" then --funny
        for i=1, #player.hand do
            player.hand[i].faceUp = true
        end
        player.cardTimer = 0
    end
    if key == "p" then --funny
        for i=1, #player.hand do
            player.hand[i].faceUp = false
        end
    end
end