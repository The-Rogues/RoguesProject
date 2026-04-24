extends Control

signal saved_texture(texture:Texture2D)

@export var textures:Array[Texture2D]
@onready var texture_container: FlowContainer = %TextureContainer

var texture_group := ButtonGroup.new()
var selected_texture:Texture2D = null

const Texture_Slot = preload(
		"res://character_creator/texture_select_slot.tscn")


func initialize():
	for i in textures.size():
		var texture = textures[i]
		var slot:Button = Texture_Slot.instantiate()
		texture_container.add_child(slot)
		
		slot.sprite.texture = texture
		slot.button_group = texture_group
		slot.toggle_mode = true
		
		slot.selected.connect(_on_texture_selected)
	
	# Force first selection
	select_random()


func select_random():
	if texture_container.get_child_count() > 0:
		var random_texture_index:int = randi_range(0, textures.size() - 1)
		var random_button = texture_container.get_child(random_texture_index)
		
		if random_button:
			random_button.set_pressed(true)
			selected_texture = textures[random_texture_index]
			saved_texture.emit(selected_texture)


func _on_texture_selected(_texture:Texture2D):
	selected_texture = _texture


func _on_cancel_button_up() -> void:
	visible = false
	pass # Replace with function body.


func _on_save_button_up() -> void:
	visible = false
	saved_texture.emit(selected_texture)
	pass # Replace with function body.
