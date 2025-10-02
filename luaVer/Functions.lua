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

function drawCard(card,pozX,pozY)
    local x = indexOf(values, card.value)
    local y = indexOf(suits, card.suit) - 1
    local i = y*14 + x
    if card.faceUp == false then
        i = 28
    end
    love.graphics.draw(cardSprite.tile, cardSprite.quads[i], pozX, pozY)

end

function drawDeck(Deck)
    for i, card in ipairs(Deck) do
        Deck[i]:setPosition(900 - i*0.2, 360+i*0.1)
        Deck[i]:draw()-- MAKE THESE PIXELS SCALABLE
    end
end