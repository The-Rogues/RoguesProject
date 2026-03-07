# --AiCardData Resource Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends CardData
class_name AiCardData

@export var default_option: CardGenOption # The CardGenOption that corresponds to the card's reference.
@export var ai_options: Array[CardGenOption] # The array of CardGenOptions for the AI to choose.
@export var gen_callback: Script # Callback function within a script used to generate the result card.
