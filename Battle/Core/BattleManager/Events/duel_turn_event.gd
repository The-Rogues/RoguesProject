extends BattleTurnEvent
class_name DuelTurnEvent

@export var player_damage:int
@export var enemy_damage:int
var target_entity:BattleEntity
var rival_label_instance:Label

const RIVAL_LABEL = preload("res://Battle/Core/BattleManager/Events/rival_label.tscn")

func initialize(new_battle_instance:BattleManager) -> void:
	super(new_battle_instance)
	new_battle_instance.new_turn_started.connect(on_turn_started)
	var canidates:Array[BattleEntity] = battle_instance.living_enemies
	target_entity = battle_instance.character_personality.offensive_trait.get_priority_target(
		canidates
	)
	target_entity.defeated.connect(_on_rival_defeated)
	
	var new_rival_label:Label = RIVAL_LABEL.instantiate()
	target_entity.add_child(new_rival_label)
	new_rival_label.global_position = target_entity.global_position
	new_rival_label.global_position.y += 50
	new_rival_label.global_position.x -= 8
	rival_label_instance = new_rival_label


func _on_rival_defeated(battle_entity:BattleEntity):
	rival_label_instance.queue_free()
	if target_entity.is_defeated:
		event_ended.emit(self)
	target_entity.defeated.disconnect(_on_rival_defeated)
	battle_instance.new_turn_started.disconnect(on_turn_started)

func on_turn_started() -> void:
	if target_entity.is_defeated:
		event_ended.emit(self)
		battle_instance.new_turn_started.disconnect(on_turn_started)
	
	var player_attack = DamageEntityAction.new()
	player_attack.damage = player_damage
	player_attack.target = TargetedBattleAction.TargetType.INHERITED
	player_attack.inherited_targeting = [target_entity] as Array[BattleEntity]
	var enemy_attack = DamageEntityAction.new()
	enemy_attack.damage = player_damage
	enemy_attack.target = TargetedBattleAction.TargetType.PLAYER
	
	battle_instance.action_queue.enqueue(
		player_attack,
		battle_instance,
		battle_instance.player_entity
	)
	battle_instance.action_queue.enqueue(
		enemy_attack,
		battle_instance,
		target_entity
	)
	pass
