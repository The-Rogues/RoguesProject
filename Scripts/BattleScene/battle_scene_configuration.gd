extends RefCounted
class_name BattleSceneConfiguration

# Should only be created by Battle Loader

var enemy_group:EnemyGroup
var character_data:CharacterData
var items:Array[ItemData]
var battle_field_schema:BattleFieldSchema

func _init(new_character_data:CharacterData, 
			new_item_datas:Array[ItemData],
			new_enemy_group:EnemyGroup,
			new_battle_field_data:BattleFieldSchema):
	
	character_data = new_character_data
	enemy_group = new_enemy_group
	items = new_item_datas
	battle_field_schema = new_battle_field_data
