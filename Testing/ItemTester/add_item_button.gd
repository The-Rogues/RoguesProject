extends PanelContainer
class_name AddItemButton


@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/HBoxContainer/Label
var data:ItemData


func initialize(data:ItemData):
	self.data = data
	texture_rect.texture = data.display_texture
	label.text = data.name
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and (event.button_index == 1 or event.button_index == 0):
			print("DEBUG: Added item: ", data.name)
			GlobalSessionManager.run_progress.player_data.add_item(data)
