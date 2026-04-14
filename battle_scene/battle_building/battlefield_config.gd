extends Resource
class_name BattleFieldConfig

## Drag in objects to spawn in that position
## WARNING: DO NOT CHANGE THE SIZE OF THIS DICTIONARY
@export var layout:Dictionary[int, ObjectData] = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
}

func get_layout_as_array() -> Array[ObjectData]:
	var new_layout:Array[ObjectData]
	for position in layout:
		new_layout.append(layout[position])
	return new_layout
