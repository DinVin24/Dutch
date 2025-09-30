values = ['ace', 'two', 'three', 'four', 'five',
          'six', 'seven', 'eight', 'nine', 'ten',
          'jack', 'queen', 'king']
suits = ['spade', 'clubs', 'heart', 'diamond']
class Card:
    def __init__(self, value, suit):
        self.value = value
        self.suit = suit

deck = [Card(value,suit) for value in values for suit in suits ]
for card in deck:
    print(card.value,card.suit)