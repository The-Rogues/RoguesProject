extends Node2D
class_name BattlePosition
## Battlefield position node that manages temporary combat opportunities.
##
## Tracks and visually represents short-lived opportunity states (such as
## offense, defense, or preservation) associated with a battle position.
## Opportunities decay over time and automatically reset once their lifespan
## expires.
##
## This node is responsible for opportunity state management and visual
## feedback only; higher-level battle logic determines when opportunities
## are created or consumed.

enum Opportunity {NONE, DEFENSE, OFFENSE, AGGRESSION, PRESERVATION, MOTIVATION}
@export var opportunity:Opportunity = Opportunity.NONE

@export var defense_color:Color
@export var offense_color:Color
@export var aggression_color:Color
@export var preservation_color:Color
@export var motivation_color:Color
@export var default_color:Color

var life_span:int = 0

@onready var opportunity_sprite: Sprite2D = $OpportunitySprite

func has_opportunity():
	return opportunity != Opportunity.NONE

func decay():
	if life_span == 0:
		return
	life_span -= 1
	if life_span == 0:
		opportunity = Opportunity.NONE
		opportunity_sprite.visible = false

func set_opportunity(new_opportunity:Opportunity):
	if has_opportunity():
		return
	life_span = randi_range(1, 3)
	opportunity = new_opportunity
	opportunity_sprite.visible = true
	
	match opportunity:
		Opportunity.DEFENSE:
			opportunity_sprite.modulate = defense_color
		Opportunity.OFFENSE:
			opportunity_sprite.modulate = offense_color
		Opportunity.AGGRESSION:
			opportunity_sprite.modulate = aggression_color
		Opportunity.PRESERVATION:
			opportunity_sprite.modulate = preservation_color
		Opportunity.MOTIVATION:
			opportunity_sprite.modulate = motivation_color
		Opportunity.NONE:
			opportunity_sprite.modulate = default_color
			opportunity_sprite.visible = false
'''
func on_player_entered_opportunity(battle_position:BattlePosition):
	if !player_entity:
		return
	
	if !battle_position.has_opportunity():
		player_on_opportunity = false
		return
	
	match battle_position.opportunity:
		BattlePosition.Opportunity.DEFENSE:
			player_entity.entity_data.defense_amplifier.increase(0.5)
		BattlePosition.Opportunity.OFFENSE:
			player_entity.entity_data.attack_amplifier.increase(0.5)
	
	player_on_opportunity = true
'''
