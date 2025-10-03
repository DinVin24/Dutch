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
        Deck[i]:draw(900 - i*0.2, 360+i*0.1)-- MAKE THESE PIXELS SCALABLE
    end
end

function clickedOwnCard(x,y,player)
    local clickedCard = player:getCardAt(x, y)
    if clickedCard then
        if player.seeCards > 0 then
            if clickedCard.faceUp == false then
                player.seeCards = player.seeCards -1
            end
            clickedCard.faceUp = true
            if player.cardTimer <= 0 then
                player.cardTimer = 160
            end
        end
        return clickedCard
    end
    return nil
end

function clickedDeck(x,y,player,deck)
    local deckX, deckY, deckW, deckH = 900, 360, 42, 60
    if x > deckX and x < deckX+deckW and y>deckY and y < deckY+deckH and player.turn then
        player.turn = false
        player.pulledCard = table.remove(deck)
        player.pulledCard.faceUp = true
    end
    return nil
end

function clickedPile(x,y,player,discard)
    if x > discard.x and x < discard.x + Card.WIDTH and y > discard.y and y < discard.y + Card.HEIGHT then
        if player.pulledCard then
            discard.value, discard.suit = player.pulledCard.value, player.pulledCard.suit
            player.pulledCard = nil
            return discard
        end
    end
    return discard
end

function handleMousePressed(x, y, button, player, GameTable)
    if button == 1 then
        clickedOwnCard(x,y,player)

        clickedDeck(x,y,player,GameTable.Deck)

        GameTable.discard = clickedPile(x,y,player,GameTable.discard)

    end
    return nil
end