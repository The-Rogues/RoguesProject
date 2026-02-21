extends Resource
class_name BattleObjectLayout

enum Rarity {COMMON, UNCOMMON, RARE, SUPER_RARE}
@export var rarity:Rarity
## Drag in objects to spawn in that position
## WARNING: DO NOT CHANGE THE SIZE OF THIS DICTIONARY
@export var layout:Dictionary[int, ObjectEntityData] = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
}

func get_layout_as_array():
	var new_layout:Array[ObjectEntityData]
	for position in layout:
		new_layout.append(layout[position])
	return layout
