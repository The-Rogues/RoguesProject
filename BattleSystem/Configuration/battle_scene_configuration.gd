extends RefCounted
class_name BattleSceneConfiguration

# Should only be created by Scene Loader
var enemies:Array[EnemyData] = []
var character_data:CharacterData = null
var items:Array[ItemData] = []
var battle_object_layout:BattleObjectLayout = null

func _init(new_character_data:CharacterData, 
			new_item_datas:Array[ItemData],
			new_enemies:Array[EnemyData],
			new_battle_object_layout:BattleObjectLayout):
	
	character_data = new_character_data
	enemies = new_enemies
	items = new_item_datas
	battle_object_layout = new_battle_object_layout
