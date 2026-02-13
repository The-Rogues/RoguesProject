extends Resource
class_name CardData
## Resource that stores information for a unique playable card.
##
## Includes a card's name, description, cost to play, and combat moves
## to perform. Intended to be used as a creatable asset that is passed
## to CardUI for initialization

enum Rarity {COMMON, UNCOMMON, RARE}
## Controls how likely the card available in shops or rewarded to the player
## in special events
@export var rarity:Rarity = Rarity.COMMON
## Sets the default cost it will take to play the card
@export var energy_cost:int = 0
## Sets what actions will be perfomed when playing the card, seperated by 
## specified target
@export var move:BattleMove

#TODO: Experiment with cards having display image 
#TODO: Implement conditional play moves depending on personality trais and weights
