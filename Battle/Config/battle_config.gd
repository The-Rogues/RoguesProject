extends Resource
class_name BattleSceneConfiguration
## RefCounted used to store temporary compact configuration data for [BattleScene]
##
## Intended to be created by a battle loading script and stored across scenes
## so that when a battle scene is loaded, it can check for pending configuration
## from a global.


@export var enemy_encounter:EnemyEncounter = null
@export var object_layout:BattleObjectLayout = null
@export var character_entity_data:EntityData = null
@export var personality_data:PersonalityData = null
@export var held_items:Array[ItemData] = []
@export var card_deck:CardDeck
@export var energy:int = 5
@export var current_character_health:int


func _init(
			new_enemy_encounter:EnemyEncounter,
			new_object_layout:BattleObjectLayout,
			new_personality_data:PersonalityData,
			new_character_entity_data:EntityData,
			items:Array[ItemData],
			new_card_deck:CardDeck,
			new_energy:int,
			new_current_character_health:int
			):
	enemy_encounter = new_enemy_encounter
	object_layout = new_object_layout
	character_entity_data = new_character_entity_data
	personality_data = new_personality_data
	held_items = items.duplicate(true)
	card_deck = new_card_deck
	energy = new_energy
	current_character_health =new_current_character_health
