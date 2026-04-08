extends Resource
class_name CardData
## Resource that stores information for a unique playable card.
##
## Includes a card's name, description, cost to play, and combat moves
## to perform. Intended to be used as a creatable asset that is passed
## to CardUI for initialization

@export var id:int = 0
## Sets the default cost it will take to play the card
@export var energy_cost:int = 0
@export var discard_after_play:bool = false
## Sets what actions will be perfomed when playing the card, seperated by 
## specified target
@export var move:BattleMove
@export var primary_action:BattleAction
@export var secondary_action:BattleAction
@export var shop_price: int = 50
#TODO: Experiment with cards having display image 
