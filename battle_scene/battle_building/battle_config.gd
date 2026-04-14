extends RefCounted
class_name BattleConfig
## Data container used by [BattleScene] to initialize battles


var enemy_encounter:EnemyEncounter = null
var battle_field_config:BattleFieldConfig = null
var player_data:PlayerData


func _init(
	_enemy_encounter:EnemyEncounter,
	_battle_field_config:BattleFieldConfig,
	_player_data:PlayerData
):
	enemy_encounter = _enemy_encounter
	battle_field_config = _battle_field_config
	player_data = _player_data
