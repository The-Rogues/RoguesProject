extends Control
class_name ShopEntry

signal hovered(shop_entry:ShopEntry)
signal selected(shop_entry:ShopEntry)

@onready var button: Button = $Container/Button
@onready var texture_rect: TextureRect = $Container/MarginContainer/Item/Texture
@onready var name_label: RichTextLabel = $Container/MarginContainer/Item/Name
@onready var amount_label: Label = $Container/MarginContainer/Cost/Amount
@onready var rarity_particles: CPUParticles2D = $Container/RarityParticles
@onready var tool_tip: ToolTip = $ToolTip
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var entry_data:ShopEntryData


func initialize(data:ShopEntryData):
	texture_rect.texture = data.texture
	name_label.text = data.name
	amount_label.text = str(data.price)
	entry_data = data
	
	button.disabled = false
	if data.special:
		rarity_particles.emitting = true
	
	tool_tip.set_tooltip(data.name, data.description, data.texture)


func _on_select_button_up() -> void:
	selected.emit(self)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	hovered.emit(self)
	var previous_pos = tool_tip.global_position
	tool_tip.visible = true
	tool_tip.top_level = true
	tool_tip.global_position = previous_pos
	pass # Replace with function body.


func _on_button_mouse_exited() -> void:
	var previous_pos = tool_tip.global_position
	tool_tip.visible = false
	tool_tip.top_level = false
	tool_tip.global_position = previous_pos
	pass # Replace with function body.


func reject():
	animation_player.play("reject")
