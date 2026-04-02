extends AbstractCreature
class_name PlayerEntity

signal carry_object_updated
signal defeated

var carried_object:ObjectEntityData = null
var battle_position:BattlePosition

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var movement_controller:PlayerMovementController = $MovementController
@onready var energy:Energy = $Stats/Energy
@onready var offensive_trait:Trait = $Stats/Offense
@onready var defensive_trait:Trait = $Stats/Defense
@onready var strategic_trait:Trait = $Stats/Strategy
@onready var sprite_flasher: SpriteFlasher = $SpriteFlasher


func initialize(run:RunProgress):
	health.initialize(run.current_health, run.player_data.health)
	energy.initialize(run.max_energy, run.max_energy)
	
	offensive_trait.initialize(
		run.player_data.personality.offensive_trait,
		run.player_data.personality.offensive_weight
	)
	
	defensive_trait.initialize(
		run.player_data.personality.defensive_trait,
		run.player_data.personality.defensive_weight
	)
	
	strategic_trait.initialize(
		run.player_data.personality.strategic_trait,
		run.player_data.personality.strategic_weight
	)
	
	movement_controller.player = self

func take_damage(amount:int, _attacker = null):
	if battle_position.object:
		battle_position.object.take_damage(amount, _attacker)
		return
	
	var damage:int = effects.apply_incoming_damage_effects(amount)
	damage = block.absorb_damage(damage)
	
	sprite_flasher.flash()
	health.take_damage(damage)


func on_destroyed():
	sprite_flasher.flash()
	await play_death_anim()
	defeated.emit()


func on_turn_entered():
	effects.on_entered_turn()
	effects.decay_effects()


func carry_object(object:ObjectEntityData):
	carried_object = object
	carry_object_updated.emit()


func place_object() -> bool:
	if !carried_object:
		return false
	
	if battle_position.object:
		return false
	
	
	battle_position.set_object(carried_object)
	carried_object = null
	carry_object_updated.emit()
	return true
