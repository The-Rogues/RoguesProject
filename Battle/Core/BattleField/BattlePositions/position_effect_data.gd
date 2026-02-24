extends Resource
class_name PositionEffectData

@export var name:String
@export var flammable:bool = false
@export var use_particles:bool = false
@export_range(1, 99) var duration:int = 1
@export var position_texture:Texture2D
@export var position_texture_color:Color
@export var particle_texture:Texture2D
@export var particle_texture_color:Color
@export var priority:int = 0

signal ended

func on_entered(entity:BattleEntity):
	pass

func on_exited(entity:BattleEntity):
	pass

func on_turn_started(entity:BattleEntity):
	duration -= 1
	
	if duration == 0:
		ended.emit()
	pass
