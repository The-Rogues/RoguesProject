extends Control
class_name ObjectSlot

@onready var object_texture: TextureRect = $PanelContainer/MarginContainer/ObjectTexture
var player:PlayerEntity


func _ready() -> void:
	visible = false


func initialize(player:PlayerEntity):
	player.carry_object_updated.connect(_on_carry_object)
	self.player = player


func _on_carry_object():
	if player.carried_object:
		visible = true
		object_texture.texture = player.carried_object.display_texture
	else:
		visible = false
