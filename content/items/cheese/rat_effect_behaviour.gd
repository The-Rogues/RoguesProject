extends StatusEffectBehaviour
class_name RatStatusEffect

const DRAW_COUNT = 2
const RAT = preload("res://content/items/cheese/Rats/rat.tscn")
const RAT_CARD = preload("res://content/items/cheese/Cards/rat_attack.tres")
var rats:Array[Rat]
var owner

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	add_rats(owner)
	instance.stack = rats.size()


func get_description(_instance:ActiveStatusEffect) -> String:
	return "You have " + str(rats.size()) + " Rats."


func get_texture() -> Texture2D:
	return load("res://content/items/cheese/Rats/rat_texture.tres")


func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if owner == null:
		owner = _creature
	
	add_rats(_creature)
	_instance.stack = rats.size()


func add_rats(_creature:AbstractCreature):
	var ran = randi_range(1, 3)
	for i in range(0, ran):
		var rat = RAT.instantiate()
		_creature.get_parent().add_child(rat)
		rat.rat_area = _creature
		rats.append(rat)
		rat.global_position = Vector2(
			rat.global_position.x, 
			_creature.global_position.y + randf()
		)
		rat.move_to(_creature.global_position)
		await rat.get_tree().create_timer(0.5).timeout
	
	if _creature is PlayerEntity:
		var card_instance = CardInstance.new(RAT_CARD)
		for i in range(0, DRAW_COUNT):
			_creature.cards.add_card_to_draw_pile(card_instance, true)
