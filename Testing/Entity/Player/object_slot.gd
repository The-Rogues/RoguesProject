extends PanelContainer
class_name ObjectSlot

@onready var object_texture: TextureRect = $PanelContainer/MarginContainer/ObjectTexture
@export var player:PlayerEntity

func _ready() -> void:
	if !player:
		return
	
	player.carry_object_updated.connect(_on_carry_object)


func _on_carry_object():
	if player.carried_object:
		visible = true
		object_texture.texture = player.carried_object.display_texture
	else:
		visible = false
