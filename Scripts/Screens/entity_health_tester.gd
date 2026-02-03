extends CanvasLayer

@export var entities:Array[BattleEntity]
@export var battle_objects:Array[BattleFieldObject]
@onready var damage_value: SpinBox = $HBoxContainer/DamageValue
@onready var heal_value: SpinBox = $HBoxContainer/HealValue

func _on_damage_button_up() -> void:
	for entity in entities:
		entity.take_damage(damage_value.value)
	for object in battle_objects:
		object.take_damage(damage_value.value)
	pass # Replace with function body.


func _on_heal_button_up() -> void:
	for entity in entities:
		entity.heal(heal_value.value)
	for object in battle_objects:
		object.heal(damage_value.value)
	pass # Replace with function body.

func _on_kill_button_up() -> void:
	for entity in entities:
		entity.kill()
	for object in battle_objects:
		object.destroy()
	pass # Replace with function body.
