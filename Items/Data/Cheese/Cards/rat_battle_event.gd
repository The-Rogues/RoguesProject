extends BattleTurnEvent
class_name RatBattleEvent

@export var draw_count:int = 2
const RAT = preload("res://Items/Data/Cheese/Rats/rat.tscn")
const RAT_CARD = preload("res://Items/Data/Cheese/Cards/rat_attack_card_data.tres")
var rats:Array[Rat]

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	add_rats()


func add_rats():
	print("RATS")
	var ran = randi_range(1, 3)
	for i in range(0, ran):
		var rat:Rat = RAT.instantiate()
		associated_entity.get_parent().add_child(rat)
		rat.rat_area = associated_entity
		rats.append(rat)
		rat.global_position = Vector2(
			rat.global_position.x, 
			associated_entity.global_position.y + randf()
		)
		rat.move_to(associated_entity.global_position)
		await rat.get_tree().create_timer(0.5).timeout
	
	if associated_entity != battle_instance.player_entity:
		return
	
	var cards:Array[CardData]
	for i in range(0, draw_count):
		cards.append(RAT_CARD.duplicate(true))
	
	battle_instance.battle_card_manager.draw_pile.add_cards(cards, true)


func on_stack():
	add_rats()
