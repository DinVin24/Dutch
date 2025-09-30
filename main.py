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
    def __copy__(self,c):
        self.value = c.value
        self.suit = c.suit

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
    def pullCard(self, deck):
        print("You just pulled: ",end="")
        deck[-1].print()
        choice = input("Press D to discard it, or choose which card you're replacing\n1 2 3 4\n")
        if choice == "D":
            return deck.pop()
        aux = self.cards[int(choice)-1]
        self.cards[int(choice)-1] = deck.pop()
        return aux


deck = [Card(value,suit) for value in values for suit in suits ]
random.shuffle(deck)

NrPlayers = 1
Players = [Player() for i in range(NrPlayers)]
for p in Players:
    p.deal(deck)

for p in Players:
    p.showCards()

for i in range(NrPlayers):
    choice = [int (x) - 1 for x in input(f"Player {i+1}, choose 2 cards to see:\n1 2 3 4\n").split()]
    Players[i].showCards(choice)



GameStatus = 1
pile = []
while GameStatus == 1:
    for p in Players:
        #pulling a card
        pile.append(p.pullCard(deck))
    GameStatus = 0

for c in pile:
    c.print()
print()
for p in Players:
    p.showCards()
# for c in deck:
#     c.print()


#
# for card in deck:
#     print(card.value, card.suit)