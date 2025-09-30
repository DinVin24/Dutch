import random

values = ['ace', 'two', 'three', 'four', 'five',
          'six', 'seven', 'eight', 'nine', 'ten',
          'jack', 'queen', 'king']
suits = ['spade', 'clubs', 'heart', 'diamond']

class Card:
    def __init__(self, value, suit):
        self.value = value
        self.suit = suit
    def print(self):
        print(self.value, self.suit)

class Player:
    def __init__(self):
        self.cards=[]
    def deal(self, d):
        for i in range(4):
            self.cards.append(d.pop())
    def showCards(self,i=None):
        if i is None:
            for card in self.cards:
                card.print()
        else:
            for x in i:
                self.cards[x].print()
        print()

deck = [Card(value,suit) for value in values for suit in suits ]
random.shuffle(deck)

NrPlayers = 4
Players = [Player() for i in range(NrPlayers)]
for p in Players:
    p.deal(deck)

for p in Players:
    p.showCards()

for i in range(NrPlayers):
    choice = [int (x) - 1 for x in input(f"Player {i+1}, choose 2 cards to see:\n1 2 3 4\n").split()]
    Players[i].showCards(choice)



#
# GameStatus = 1
# while GameStatus == 1:
#     for i in range(NrPlayers):
#         print(deck[0].value, deck[0].suit)
#
# for card in deck:
#     print(card.value, card.suit)