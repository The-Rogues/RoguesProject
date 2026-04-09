extends PanelContainer
class_name ShopEntry

signal hovered(data:ShopEntryData)
signal selected(data:ShopEntryData)

@onready var button: Button = $Button
@onready var texture_rect: TextureRect = $MarginContainer/Item/Texture
@onready var name_label: RichTextLabel = $MarginContainer/Item/Name
@onready var amount_label: Label = $MarginContainer/Cost/Amount
@onready var rarity_particles: CPUParticles2D = $RarityParticles


var entry_data:ShopEntryData


func initialize(data:ShopEntryData):
	texture_rect.texture = data.texture
	name_label.text = data.name
	amount_label.text = str(data.price)
	entry_data = data
	
	button.disabled = false
	if data.special:
		rarity_particles.emitting = true


func _on_select_button_up() -> void:
	selected.emit(entry_data)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	hovered.emit(entry_data)
	pass # Replace with function body.
