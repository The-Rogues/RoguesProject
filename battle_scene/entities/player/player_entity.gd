extends AbstractCreature
class_name PlayerEntity

signal carry_object_updated

var carried_object:ObjectData = null
var battle_position:BattlePosition
var data:PlayerData = null

@onready var sprite_2d: HitFlash = $Sprite2D
@onready var movement_controller:PlayerMovementController = $MovementController
@onready var energy:Energy = $Stats/Energy
@onready var offensive_trait:Trait = $Stats/Offense
@onready var defensive_trait:Trait = $Stats/Defense
@onready var strategic_trait:Trait = $Stats/Strategy
@onready var cards:CardHandler = $CardHandler
@onready var object_slot: ObjectSlot = $ObjectSlot
@onready var damage_numbers_spawn: Node2D = $DamageNumbersSpawn


func initialize(_data:PlayerData):
	health.initialize(_data.current_health, _data.max_health)
	energy.initialize(_data.max_energy, _data.max_energy)
	
	offensive_trait.initialize(
			_data.personality.offensive_trait,
			_data.personality.offensive_weight)
	
	defensive_trait.initialize(
			_data.personality.defensive_trait,
			_data.personality.defensive_weight)
	
	strategic_trait.initialize(
			_data.personality.strategic_trait,
			_data.personality.strategic_weight)
	
	cards.initialize(_data.cards, self)
	data = _data
	_data.connect_to_player_entity(self)
	
	movement_controller.player = self
	stat_display.initialize(self)
	object_slot.initialize(self)
	
	health.died.connect(on_destroyed)


func take_damage(amount:int, _attacker = null):
	if battle_position.has_object():
		battle_position.object.take_damage(amount, _attacker)
		return
	
	var damage:int = effects.apply_incoming_damage_effects(amount)
	damage = block.absorb_damage(damage)
	
	DamageNumber.display_number(damage, damage_numbers_spawn.global_position)
	sprite_2d.flash()
	health.take_damage(damage)


func apply_status_effect(effect:StatusEffectConfig):
	if battle_position.object:
		return
	
	effects.add_effect(effect.behaviour, effect.duration, effect.stack)


func on_destroyed():
	data.connect_to_player_entity(self)
	sprite_2d.flash()
	await play_death_anim()
	defeated.emit(self)


func enter_turn():
	super()
	energy.refill()


func resolve_card(card:Card, resolver:ActionResolver, play_hand:PlayerCardHand):
	if energy.spend(card.instance.energy_cost):
		cards.move_drawn_card_into_discard_pile(card.instance)
		play_hand.confirm_play(card)
		resolver.process_actions(card.instance.data.play_actions, self)
		
		if card.instance.data.type == CardData.Type.ATTACK:
			play_attack_anim()
	else:
		play_hand.reject_play()


func carry_object(object:ObjectData) -> bool:
	if carried_object:
		return false
	
	carried_object = object
	carry_object_updated.emit()
	
	if !battle_position.has_object():
		place_object()
	
	return true


func place_object() -> bool:
	if !carried_object:
		return false
	
	if battle_position.object:
		return false
	
	
	battle_position.set_object(carried_object)
	carried_object = null
	carry_object_updated.emit()
	return true
