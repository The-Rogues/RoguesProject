extends AbstractCreature
class_name PlayerEntity

signal played_card(card:CardInstance)
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

@onready var melee_weapon_animator: AnimationPlayer = %MeleeWeaponAnimator
@onready var ranged_weapon_animator: AnimationPlayer = %RangedWeaponAnimator
@onready var ranged_weapon: Node2D = %RangedWeapon
@onready var ranged_weapon_sprite: Sprite2D = $RangedWeapon/Sprite2D
@onready var melee_weapon_sprite: Sprite2D = $MeleeWeapon/Sprite2D



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
	movement_controller.entered_new_position.connect(_on_enterned_new_position)
	projectile_launcher.fired_projectile.connect(_on_projectile_fired)


func take_damage(amount:int, _attacker = null):
	var damage:int = effects.apply_incoming_damage_effects(amount)
	damage = block.absorb_damage(damage)
	
	DamageNumber.display_number(damage, damage_numbers_spawn.global_position)
	sprite_2d.flash()
	health.take_damage(damage)
	
	effects.on_attacked(_attacker)
	
	if _attacker is AbstractEntity:
		_attacker.set_last_attacked_entity(self)


func apply_status_effect(effect:StatusEffectConfig, pass_object:bool = false):
	if battle_position.has_object() and !pass_object:
		return
	
	effects.add_effect(effect.behaviour, effect.duration, effect.stack)


func on_destroyed():
	data.connect_to_player_entity(self)
	sprite_2d.flash()
	await play_death_anim()
	defeated.emit(self)
	sprite_2d.visible = false


func enter_turn(_turn_count:int):
	block.set_to_zero()
	effects.on_entered_turn()
	#effects.decay_status_effects()
	energy.refill()
	turn_entered.emit()


func resolve_card(card:Card, resolver:ActionResolver, play_hand:PlayerCardHand):
	if energy.spend(card.instance.energy_cost):
		cards.move_drawn_card_into_discard_pile(card.instance)
		play_hand.confirm_play(card)
		resolver.process_actions(card.instance.data.play_actions, self)
		
		effects.process_played_card(card.instance, resolver)
		
		played_card.emit(card.instance)
		if card.instance.data.type == CardData.Type.ATTACK:
			play_attack_anim()
			melee_weapon_animator.play("swing")
		elif card.instance.data.type == CardData.Type.RANGED:
			ranged_weapon_animator.play("fire")
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
	
	if battle_position.has_object():
		return false
	
	battle_position.place_object(carried_object)
	carried_object = null
	carry_object_updated.emit()
	return true


func _on_enterned_new_position():
	place_object()
