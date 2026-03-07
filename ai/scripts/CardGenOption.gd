# --CardGenOption Resource Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Resource
class_name CardGenOption

@export var energy_cost: int # The energy cost of the option.
@export var card_option: CardGenConst.CardGenEnum # The option's identifier.
