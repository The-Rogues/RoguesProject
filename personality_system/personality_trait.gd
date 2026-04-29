extends Resource
class_name PersonalityTrait
## Defines Personality Traits

enum TraitCategory { OFFENSIVE, DEFENSIVE, STRATEGIC }
#enum EnemyPreference { HEALTHIEST, WEAKEST, DANGEROUS, INTELEGENT }

@export var display_texture:Texture2D
@export var name:String
@export_multiline var description:String
@export var trait_category:TraitCategory
@export var enemy_targeting_preference:MonsterData.AttackTargetingCategory
@export var enemy_targeting_bias:Array[String]
@export var object_targeting_preference:ObjectData.MoveTargetingCategory

@export var card_loot_pool:Array[CardData]
@export var starter_cards:Array[CardData]


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
