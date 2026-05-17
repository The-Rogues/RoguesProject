extends AbstractCreature
class_name PlayerEntity

signal played_card(card:CardInstance)
signal carry_object_updated
signal start_ai_processing
signal end_ai_processing
signal summoned_friend(friend:Friend)

var carried_object:ObjectData = null
var battle_position:BattlePosition
var data:PlayerData = null
var damage_taken_this_turn:int = 0
var damage_taken_last_turn:int = 0
var attacked_this_turn: bool = false
var attacked_last_turn: bool = false

var unused_energy_last_turn: int = 0

@onready var sprite_2d: HitFlash = $Sprite2D
@onready var movement_controller:PlayerMovementController = $MovementController
@onready var energy:Energy = $Stats/Energy
@onready var offensive_trait:Trait = Trait.new()
@onready var defensive_trait:Trait = Trait.new()
@onready var strategic_trait:Trait = Trait.new()
@onready var cards:CardHandler = $CardHandler
@onready var object_slot: ObjectSlot = $ObjectSlot
@onready var damage_numbers_spawn: Node2D = $DamageNumbersSpawn

@onready var melee_weapon_animator: AnimationPlayer = %MeleeWeaponAnimator
@onready var ranged_weapon_animator: AnimationPlayer = %RangedWeaponAnimator
@onready var ranged_weapon: Node2D = %RangedWeapon
@onready var ranged_weapon_sprite: Sprite2D = $RangedWeapon/Sprite2D
@onready var melee_weapon_sprite: Sprite2D = $MeleeWeapon/Sprite2D

var ai_processer_scn: PackedScene = preload("res://ai/processer/AiCardProcesser.tscn")
var ai_processer: AiCardProcesser = ai_processer_scn.instantiate()
var friends:Array[Friend] = []

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
	
	sprite_2d.texture = data.character_texture
	melee_weapon_sprite.texture = data.melee_weapon_texture
	ranged_weapon_sprite.texture = data.ranged_weapon_texture
	
	stat_display.initialize(self)
	object_slot.initialize(self)
	
	health.died.connect(on_destroyed)
	movement_controller.entered_new_position.connect(_on_enterned_new_position)
	projectile_launcher.fired_projectile.connect(_on_projectile_fired)
	
	add_to_group("Player")
	add_child(ai_processer)



func take_damage(amount:int, _attacker = null):
	var damage:int = effects.apply_incoming_damage_effects(amount)
	
	if !_object_intercept_attack(damage, _attacker):
		attacker = _attacker
		damage = block.absorb_damage(damage)
		DamageNumber.display_number(damage, damage_numbers_spawn.global_position)
		sprite_2d.flash()
		health.take_damage(damage)
		damage_taken_this_turn += damage
		
		if !_attacker is Projectile:
			effects.on_attacked(_attacker)
		
		if damage > 0:
			if !_attacker is Projectile:
				effects.on_damaged(_attacker, self)
			else:
				effects.on_damaged(null, self)
		
		if _attacker is AbstractEntity:
			_attacker.set_last_attacked_entity(self)
		
		if _attacker is Projectile and _attacker.source is AbstractEntity:
			_attacker.source.set_last_attacked_entity(self)


func apply_status_effect(effect:StatusEffectConfig, pass_object:bool = false):
	if battle_position.has_object() and !pass_object:
		return
	
	effects.add_effect(effect.behaviour, effect.duration, effect.stack, effect.turn_entered)


func on_destroyed():
	data.connect_to_player_entity(self)
	sprite_2d.flash()
	await play_death_anim()
	defeated.emit(self)
	sprite_2d.visible = false


func enter_turn(_turn_count:int, turn_one: bool = false):
	damage_taken_last_turn = damage_taken_this_turn
	damage_taken_this_turn = 0
	
	attacked_last_turn = attacked_this_turn
	attacked_this_turn = false
	
	block.set_to_zero()
	#effects.on_entered_turn()
	#effects.decay_status_effects()
	if !turn_one:
		record_end_turn_state()
	energy.refill()
	turn_entered.emit()


func resolve_card(card:Card, resolver:ActionResolver, play_hand:PlayerCardHand):
	if energy.spend(card.instance.energy_cost):
		cards.move_drawn_card_into_discard_pile(card.instance)
		play_hand.confirm_play(card)
		
		if card.instance.data is AiCardData:
			start_ai_processing.emit()
			var processed_card: CardData = await ai_processer.process_card(
				data.personality,
				card.instance.data
			)
			var processed_card_instance: CardInstance = CardInstance.new(processed_card)
			cards.add_card_to_draw_pile(
				processed_card_instance, 
				true
			)
			cards.draw_cards(1)
			end_ai_processing.emit()
		else:
			resolver.process_actions(card.instance.data.play_actions, self)
		
			effects.process_played_card(card.instance, resolver)
		
			played_card.emit(card.instance)
			Events.energy_used.emit(card.instance.energy_cost)
			if card.instance.data.type == CardData.Type.ATTACK:
				attacked_this_turn = true
				play_attack_anim()
				melee_weapon_animator.play("swing")
			elif card.instance.data.type == CardData.Type.RANGED:
				attacked_this_turn = true
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
	Events.object_placed.emit(carried_object)
	carried_object = null
	carry_object_updated.emit()
	return true


func _on_enterned_new_position():
	place_object()


func record_end_turn_state():
	unused_energy_last_turn = energy.value


func _object_intercept_attack(damage:int, _attacker) -> bool:
	if !_attacker is MonsterEntity:
		return false
	if _attacker is Projectile:
		return false
	
	if battle_position.has_object() and battle_position.get_object().health.is_alive:
		battle_position.get_object().take_damage(damage, _attacker)
		return true
	else:
		return false


func register_friend(friend:Friend):
	friends.append(friend)
	summoned_friend.emit(friend)
	Events.friend_summoned.emit(friend)
