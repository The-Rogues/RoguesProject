# --Card Generation Constants Definition File--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends RefCounted
class_name CardGenConst

enum CardGenEnum {
	stdatk, # A standard amount of attack.
	stddef, # A standard amount of defense.
	dblatk, # Adds a small amount of attack and splits attack into two strikes.
	atkall # Adds a small amount of attack and attacks all enemies.
}

# Map for turning the enumerations into strings within the prompt.
const CardGenMap: Dictionary[CardGenEnum, String] = {
	CardGenEnum.stdatk: "stdatk",
	CardGenEnum.stddef: "stddef",
	CardGenEnum.dblatk: "dblatk",
	CardGenEnum.atkall: "atkall"
}
