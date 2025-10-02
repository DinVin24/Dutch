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

function handleMousePressed(x, y, button, player)
    if button == 1 then
        local clickedCard = player:getCardAt(x, y)
        if clickedCard and player.seeCards > 0 then
            player.seeCards = player.seeCards -1
            clickedCard.faceUp = true
            if player.cardTimer <=0 then
                player.cardTimer = 160
            end
            return clickedCard
        end
    end
    return nil
end