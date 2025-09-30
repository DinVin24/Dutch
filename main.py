import random

values = ['ace', 'two', 'three', 'four', 'five',
          'six', 'seven', 'eight', 'nine', 'ten',
          'jack', 'queen', 'king']
suits = ['spade', 'club', 'heart', 'diamond']

class Card:
    def __init__(self, value, suit):
        self.value = value
        self.suit = suit
    def __str__(self):
        return f"{self.value} of {self.suit}s"
    def swap(self,c):
        self.value, c.value = c.value, self.value
        self.suit, c.suit = c.suit, self.suit

NrPlayers = 4

class Player:
    def __init__(self):
        self.cards=[]
        self.score=0
    def deal(self, d):
        for i in range(4):
            self.cards.append(d.pop())
    def showCards(self,i=None):
        if i is None:
            for card in self.cards:
                print(card)
        else:
            for x in i:
                print(self.cards[x])
        print()
    def pullCard(self, deck):
        print("You just pulled: ",end="")
        print(deck[-1])
        choice = input("Press D to discard it, or choose which card you're replacing\n1 2 3 4\n")
        if choice == "D":
            return deck.pop()
        aux = self.cards[int(choice)-1]
        self.cards[int(choice)-1] = deck.pop()
        return aux
    def swapCards(self, P):
        #Jack special card
        p1,p2 = [int (x) for x in input(f"Choose the players whose cards you'll swap. Numbers from 1-{NrPlayers}\n").split()]
        c1 = int(input("Choose the first card\n"))
        c2 = int(input("Choose the second card\n"))
        P[p1-1].cards[c1-1].swap(P[p2-1].cards[c2-1])
    def revealCard(self, P):
        #Queen special card
        p = int(input("Choose the player whose card you want to reveal\n"))
        c = int(input("Choose the card you want to reveal\n"))
        print(P[p-1].cards[c-1])
    #TODO: JUMPING IN
    # DECLARING DUTCH
    # WINNING AND LOSING I GUESS
    def calculateScore(self):
        for card in self.cards:
            if card.value == 'king' and card.suit == 'diamond':
                continue
            self.score += values.index(card.value) + 1

def checkSpecialCards(card, p, Players):
    if card.value == 'jack':
        p.swapCards(Players)
    elif card.value == 'queen':
        p.revealCard(Players)


deck = [Card(value,suit) for value in values for suit in suits ]
random.shuffle(deck)

Players = [Player() for i in range(NrPlayers)]
for p in Players:
    p.deal(deck)
    p.calculateScore()

for p in Players:
    p.showCards()
    print(p.score)
    print()

for i in range(NrPlayers):
    choice = [int (x) - 1 for x in input(f"Player {i+1}, choose 2 cards to see:\n1 2 3 4\n").split()]
    Players[i].showCards(choice)

GameStatus = 1
pile = []
while GameStatus == 1:
    for p in Players:
        #pulling a card
        pile.append(p.pullCard(deck))
        checkSpecialCards(pile[-1], p, Players)
    GameStatus = 0

for c in pile:
    print(c)
print()
for p in Players:
    p.showCards()
# for c in deck:
#     print(c)

#
# for card in deck:
#     print(card.value, card.suit)