extends HBoxContainer
class_name PreferenceContainer

func add_icon(in_texture: Texture2D):
	alignment = BoxContainer.ALIGNMENT_BEGIN
	var display_rect: TextureRect = TextureRect.new()
	display_rect.texture = in_texture
	display_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	display_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	display_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	display_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	display_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	display_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_theme_constant_override("separation", 4)
	add_child(display_rect)


func clear_icons():
	var cont_children = get_children()
	for i in range(0, cont_children.size()):
		cont_children[i].queue_free()
