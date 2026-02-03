extends Resource
class_name BattleFieldSchema

enum Layout {RANDOM, SEPERATED, CENTER, SPLIT}

@export var layout_options:Layout = Layout.RANDOM
@export var possible_objects:Array[BattleObjectData]

func get_battle_field_layout():
	var layout:Array[BattleObjectData]
	match layout_options:
		Layout.RANDOM:
			for i in range(0, 5):
				if randf() > 0.5:
					layout.append(null)
					pass
				else:
					if possible_objects.is_empty():
						layout.append(null)
					else:
						layout.append(possible_objects.pick_random())
		Layout.SEPERATED:
			layout = [
				possible_objects.pick_random(),
				null,
				possible_objects.pick_random(),
				null,
				possible_objects.pick_random()
			]
		Layout.CENTER:
			layout = [
				null,
				null,
				possible_objects.pick_random(),
				null,
				null
			]
		Layout.SPLIT:
			layout = [
				null,
				possible_objects.pick_random(),
				null,
				possible_objects.pick_random(),
				null
			]
	return layout
