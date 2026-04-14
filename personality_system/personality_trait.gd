extends Resource
class_name PersonalityTrait
## Defines Personality Traits

enum TraitCategory { OFFENSIVE, DEFENSIVE, STRATEGIC }
enum EnemyPreference { STRONGEST, WEAKEST }

@export var name:String
@export_multiline var description:String
@export var trait_category:TraitCategory
@export var enemy_targeting_preference:EnemyPreference
@export var enemy_targeting_bias:Array[String]
@export var object_preference:ObjectData.Role

@export var card_loot_pool:Array[CardData]
@export var starter_cards:Array[CardData]

##TODO: Fletcher, this is the function called to decide which enemy is targeted
## Choosest the highest priority target given the biases of personality traits.
func choose_enemy_target(enemies:Array[MonsterEntity]) -> MonsterEntity:
	return enemies.pick_random()


func get_strongest_target(enemies:Array[MonsterEntity]) -> MonsterEntity:
	if enemies.is_empty():
		return null
	
	var healthiest:MonsterEntity = enemies[0]
	for i in range(1, enemies.size()):
		if enemies[i].health.value > healthiest.health.value:
			healthiest = enemies[i]
	
	return healthiest


func get_weakest_target(enemies:Array[MonsterEntity]) -> MonsterEntity:
	if enemies.is_empty():
		return null
	
	var weakest:MonsterEntity = enemies[0]
	for i in range(1, enemies.size()):
		if enemies[i].health.value < weakest.health.value:
			weakest = enemies[i]
	
	return weakest
