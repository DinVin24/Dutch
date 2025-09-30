import random

values = ['ace', 'two', 'three', 'four', 'five',
          'six', 'seven', 'eight', 'nine', 'ten',
          'jack', 'queen', 'king']
suits = ['spade', 'clubs', 'heart', 'diamond']
class Card:
    def __init__(self, value, suit):
        self.value = value
        self.suit = suit
class Player:
    def __init__(self):
        self.cards=[]

deck = [Card(value,suit) for value in values for suit in suits ]
random.shuffle(deck)

NrPlayers = 4
Players = [Player() for i in range(NrPlayers)]
for p in Players:
    for i in range(4):
        p.cards.append(deck.pop())

for p in Players:
    for card in p.cards:
        print(card.value, card.suit)
    print()


for card in deck:
    print(card.value, card.suit)