extends Resource
class_name BattlePositionData

enum Opportunity {NONE, DEFENSE, OFFENSE, AGGRESSION, PRESERVATION, MOTIVATION}
@export var opportunity:Opportunity = Opportunity.NONE
@export var object_scene:PackedScene
