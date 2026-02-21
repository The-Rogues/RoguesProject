extends BattleTurnEvent
class_name DuelTurnEvent

var player_entity:BattleEntity
var enemy_entity:BattleEntity
@export var player_damage:int
@export var enemy_damage:int

func _init(
	new_player_entity:BattleEntity,
	new_enemy_entity:BattleEntity,
	player_damage:int,
	enemy_damage:int
) -> void:
	self.player_entity = new_player_entity
	self.enemy_entity = new_enemy_entity
	self.player_damage = player_damage
	self.enemy_damage = enemy_damage

func on_turn_started(battle_instance:BattleManager) -> void:
	await player_entity.take_damage(enemy_damage)
	await enemy_entity.take_damage(player_damage)
	pass
