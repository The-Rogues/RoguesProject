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
	atkall, # Adds a small amount of attack and attacks all enemies.
	strength, # Player gains strength as a side effect of the action.
	discount
}

# Map for turning the enumerations into strings within the prompt.
const CardGenNames: Dictionary[CardGenEnum, String] = {
	CardGenEnum.stdatk: "stdatk",
	CardGenEnum.stddef: "stddef",
	CardGenEnum.dblatk: "dblatk",
	CardGenEnum.atkall: "atkall",
	CardGenEnum.strength: "strength",
	CardGenEnum.discount: "discount"
}

const CardGenDefs: Dictionary[CardGenEnum, String] = {
	CardGenEnum.stdatk: "Adds a standard ammount of attack damage to an action.",
	CardGenEnum.stddef: "Adds a standard ammount of sheild, which blocks enemy damage, to an action.",
	CardGenEnum.dblatk: "Adds a small ammount of attack damage to an action. The action's attack damage is split into two strikes.",
	CardGenEnum.atkall: "Adds a small ammount of attack damage to an action. The action's attack damage is applied to all enemies.",
	CardGenEnum.strength: "User gets stronger after using the action.",
	CardGenEnum.discount: "Less energy penalty."
}
