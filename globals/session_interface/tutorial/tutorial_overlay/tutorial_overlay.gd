extends Control
class_name TutorialOverlay

enum TutorialOverlayPreset {
	CENTER,
	INFOBAR,
	ENEMIES,
	OBJECTS,
	PLAYER,
	CARDS
}

@export var header_text: String
@export var display_image: Texture2D
@export var body_text: String
@export var container_scale: Vector2
@export var preset: TutorialOverlayPreset

@onready var info_panel: Control = %InfoPanel
@onready var highlight_panel: Control = %HighlightPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_panel.initialize(
		header_text,
		display_image,
		body_text,
		container_scale
	)
	set_up_preset()

func set_up_preset() -> void:
	match preset:
		TutorialOverlayPreset.CENTER:
			highlight_panel.visible = false
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER, true)
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= container_scale
		TutorialOverlayPreset.INFOBAR:
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= Vector2(0.5, 0.5)
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER_LEFT, true)
			info_panel.position.x += 140
			info_panel.position.y -= 100
			highlight_panel.set_anchors_preset(LayoutPreset.PRESET_TOP_WIDE, true)
			highlight_panel.custom_minimum_size.y = 80
			highlight_panel.size.y = 80
		TutorialOverlayPreset.ENEMIES:
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= Vector2(0.5, 0.5)
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER_LEFT, true)
			info_panel.position.x += 140
			info_panel.position.y += 40
			highlight_panel.set_anchors_preset(LayoutPreset.PRESET_TOP_WIDE, true)
			highlight_panel.custom_minimum_size.y = 120
			highlight_panel.offset_top = 100
		TutorialOverlayPreset.OBJECTS:
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= Vector2(0.5, 0.5)
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER_LEFT, true)
			info_panel.position.x += 140
			info_panel.position.y -= 165
			highlight_panel.set_anchors_preset(LayoutPreset.PRESET_TOP_WIDE, true)
			highlight_panel.custom_minimum_size.y = 120
			highlight_panel.offset_top = 300
		TutorialOverlayPreset.PLAYER:
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= Vector2(0.5, 0.5)
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER_LEFT, true)
			info_panel.position.x += 140
			info_panel.position.y -= 75
			highlight_panel.set_anchors_preset(LayoutPreset.PRESET_TOP_WIDE, true)
			highlight_panel.custom_minimum_size.y = 120
			highlight_panel.offset_top = 390
		TutorialOverlayPreset.CARDS:
			info_panel.pivot_offset = info_panel.size / 2
			info_panel.custom_minimum_size *= Vector2(0.5, 0.5)
			info_panel.set_anchors_preset(LayoutPreset.PRESET_CENTER_LEFT, true)
			info_panel.position.x += 140
			info_panel.position.y += 65
			highlight_panel.set_anchors_preset(LayoutPreset.PRESET_TOP_WIDE, true)
			highlight_panel.custom_minimum_size.y = 120
			highlight_panel.offset_top = 530

func connect_to_button(in_call: Callable) -> void:
	info_panel.connect_to_button(in_call)
