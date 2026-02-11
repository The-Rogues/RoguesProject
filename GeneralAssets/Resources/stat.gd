extends Resource
class_name Stat

signal increased(before:float, after:float, amount:float)
signal decreased(before:float, after:float, amount:float)
signal max_reached
signal min_reached
signal value_changed(current_value:float)

@export var max_value:float
@export var min_value:float
@export var value:float
@export var max_on_start:bool

func _init(
	max:float = 0.0,
	min:float = 0.0,
	starting_value:float = 0.0,
	maximize_on_start:bool = false
) -> void:
	max_value = max
	min_value = min
	value = starting_value
	max_on_start = maximize_on_start
	resource_local_to_scene = true
	pass

func initialize() -> void:
	if max_on_start:
		value = max_value

func set_to_max():
	value = max_value
	max_reached.emit()
	value_changed.emit(value)

func set_to_min():
	value = min_value
	min_reached.emit()
	value_changed.emit(value)

func reduce(amount:float):
	var last_value = value
	value = max(min_value, value - amount)
	
	if value == min_value:
		min_reached.emit()
	elif value != last_value:
		decreased.emit(last_value, value, amount)
	value_changed.emit(value)

func increase(amount:float):
	var last_value = value
	value = min(max_value, value + amount)
	
	if value == max_value:
		max_reached.emit()
	elif value != last_value:
		increased.emit(last_value, value, amount)
	value_changed.emit(value)
