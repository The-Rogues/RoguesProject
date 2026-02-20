extends PanelContainer

@onready var icon: TextureRect = $MarginContainer/Texture
@onready var stack_label: Label = $StackLabel


func initialize(enemy_data:BattleEntityData):
	enemy_data.new_move_chosen.connect(_on_move_chosen)

func _on_move_chosen(new_move:BattleMove):
	icon.texture = new_move.action_display_icon
