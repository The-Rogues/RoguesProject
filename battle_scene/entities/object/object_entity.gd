extends AbstractEntity
class_name ObjectEntity

signal interacted(object:ObjectEntity)
signal player_entered
signal player_exited
signal destroyed(object:ObjectEntity)

var data:ObjectData
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: HitFlash = $Sprite2D
@onready var object_stat_display: ObjectStatDisplay = $ObjectStatDisplay
@onready var damage_numbers_spawn: Node2D = $DamageNumbersSpawn
@onready var collision_box: StaticBody2D = %CollisionBox
@onready var hurt_box: Area2D = %HurtBox
@onready var object_tooltip: PanelContainer = %ObjectTooltip


func initialize(_data:ObjectData):
	data = _data
	health.initialize(_data.health, data.health)
	sprite_2d.texture = _data.display_texture
	object_stat_display.initialize(self)
	health.died.connect(on_destroyed)
	object_tooltip.initialize(data)


func take_damage(amount:int, _attacker = null):
	attacker = _attacker
	health.take_damage(amount)
	DamageNumber.display_number(amount, damage_numbers_spawn.global_position)
	
	sprite_2d.flash()
	
	resolve_hit_interaction()
	
	if _attacker is AbstractEntity:
		_attacker.set_last_attacked_entity(self)


func on_destroyed():
	hurt_box.monitorable = false
	collision_box.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	#queue_actions.emit(data.on_destroyed_actions)
	if data.interaction == ObjectData.InteractionOption.ON_DESTROYED:
		await interact()
	if (data.interaction == ObjectData.InteractionOption.ON_PLAYER_DESTROYED and
		attacker is PlayerEntity):
		await interact()
	
	await sprite_2d.flash()
	await play_destroyed_anim()
	destroyed.emit(self)


func enter_turn(_turn_count:int):
	if data.interaction != ObjectData.InteractionOption.ON_ENTERED_TURN:
		return
	
	if _turn_count % data.turn_interaction_counter == 0:
		interact()
	turn_entered.emit()


func on_placed():
	pass


func on_player_entered():
	player_entered.emit()


func on_player_exited():
	player_exited.emit()


func interact():
	await play_action_anim()
	interacted.emit(self)


func play_idle_anim():
	animation_player.play("idle")


func play_destroyed_anim():
	animation_player.play("destroyed")
	await animation_player.animation_finished


func play_action_anim():
	animation_player.play("action")
	await animation_player.animation_finished


func resolve_hit_interaction():
	match data.interaction:
		ObjectData.InteractionOption.ON_HIT:
			await interact()
		ObjectData.InteractionOption.ON_PLAYER_HIT:
			if attacker is PlayerEntity:
				await interact()
		ObjectData.InteractionOption.ON_ENEMY_HIT:
			if attacker is MonsterEntity:
				await interact()
		_:
			return


func _on_hover_area_mouse_entered() -> void:
	var pos = object_tooltip.global_position
	object_tooltip.top_level = true
	object_tooltip.visible = true
	object_tooltip.global_position = pos
	pass # Replace with function body.


func _on_hover_area_mouse_exited() -> void:
	var pos = object_tooltip.global_position
	object_tooltip.top_level = false
	object_tooltip.visible = false
	object_tooltip.global_position = pos
