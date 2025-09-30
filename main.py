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
        p.cards.append(deck.pop(0))

for p in Players:
    for card in p.cards:
        print(card.value, card.suit)
    print()

for i in range(NrPlayers):
    choice = [int (x) - 1 for x in input(f"Player {i+1}, choose 2 cards to see:\n1 2 3 4\n").split()]
    print(Players[i].cards[choice[0]].value, Players[i].cards[choice[0]].suit)
    print(Players[i].cards[choice[1]].value, Players[i].cards[choice[1]].suit)



#
# GameStatus = 1
# while GameStatus == 1:
#     for i in range(NrPlayers):
#         print(deck[0].value, deck[0].suit)
#


# for p in Players:
#     for card in p.cards:
#         print(card.value, card.suit)
#     print()
#
#
# for card in deck:
#     print(card.value, card.suit)