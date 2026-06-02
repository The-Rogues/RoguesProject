extends Control
class_name Card

signal hovered(card: Card, active:bool)
signal clicked(card: Card)
signal launched

var instance:CardInstance

@onready var card_name_label: Label = %CardNameLabel
@onready var card_cost_label: Label = $CardCostContainer/CardCostLabel
@onready var card_description_label: RichTextLabel = $CardDescriptionArea/CardDescriptionLabel
@onready var card_type_label: Label = $CardTypePlaque/CardTypeLabel
@onready var display_texture_rect: TextureRect = %DisplayTextureRect
@onready var card_edge: PanelContainer = %CardEdge
@onready var sparkles: CPUParticles2D = %Sparkles
@onready var poof: CPUParticles2D = %Poof


var base_scale: Vector2
var hover_scale := 0.08
var in_play_area := false
var check_for_play_area:bool = true
var draggable:bool = false
var interaction_mode:bool = false


func initialize(_instance:CardInstance):
	instance = _instance
	
	if _instance.data.display_texture:
		display_texture_rect.texture = _instance.data.display_texture
	card_name_label.text = _instance.data.name
	card_description_label.text = parse_card_desciption(_instance.data.description)
	card_type_label.text = _instance.data.get_type_to_string()
	card_cost_label.text = str(_instance.energy_cost)
	base_scale = scale
	_instance.updated.connect(update_ui)
	
	match _instance.data.category:
		CardData.Category.TRAITLESS:
			card_edge.self_modulate = Color("ffffffff")
		CardData.Category.OFFENSIVE:
			card_edge.self_modulate = Color("f53c40")
		CardData.Category.DEFENSIVE:
			card_edge.self_modulate = Color("3dccff")
		CardData.Category.STRATEGIC:
			card_edge.self_modulate = Color("aef300")
		CardData.Category.LEGENDARY:
			card_edge.modulate = Color(0.998, 0.218, 0.594, 1.0)
			sparkles.emitting = true
		CardData.Category.JUNK:
			card_edge.self_modulate = Color(255, 255, 0)

func update_ui():
	card_cost_label.text = str(instance.energy_cost)
	parse_card_desciption(instance.data.description)


func parse_card_desciption(base_description:String) -> String:
	var attack_regex:RegEx = RegEx.new()
	attack_regex.compile("get_atk\\d+")
	var result = attack_regex.search(base_description)
	
	if !result:
		return base_description
	
	var number:int = get_string_number(result)
	var battle_scene:BattleScene = get_tree().current_scene as BattleScene
	if battle_scene:
		var player:PlayerEntity = battle_scene.find_child(
			"PlayerEntity", 
			true, 
			false
		)
		if player:
			number = player.effects.apply_attack_damage_effects(number)
	
	return parse_number(
			base_description,
			result.get_start(),
			result.get_end(),
			number
	)


func get_string_number(regex_match:RegExMatch) -> int:
	var numbers_regex:RegEx = RegEx.new()
	numbers_regex.compile("\\d+")
	
	var result = numbers_regex.search(regex_match.get_string())
	if result:
		return result.get_string().to_int()
	else:
		return 0


func parse_number(
	string:String,
	start:int, 
	end:int, 
	number:int
) -> String:
	var prefix = string.substr(0, start)
	var suffix = string.substr(end, string.length())
	return prefix + str(number) + suffix


func launch_towards(target_pos: Vector2, reparent:bool = true) -> void:
	var root := get_tree().current_scene
	var start_pos := global_position

	if reparent:
		reparent(root)
	global_position = start_pos
	
	# bring to front so it renders above everything
	z_index = 1000
	
	var tween := create_tween()
	tween.set_parallel(true)
	
	launched.emit()
	
	tween.tween_property(
		self, 
		"global_position", 
		target_pos, 
		0.4
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# Scale down to half
	tween.tween_property(
		self, 
		"scale", 
		base_scale * 0.5, 
		0.4
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# slight fade-out for polish
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.4
	)
	
	# Cleanup when done
	tween.finished.connect(queue_free)


func poof_card():
	visible = false
	poof.finished.connect(poof.queue_free)
	poof.finished.connect(queue_free)
	
	poof.reparent(get_tree().current_scene, true)
	poof.emitting = true


func _gui_input(event: InputEvent) -> void:
	if interaction_mode == false:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)


func blow_up(active: bool) -> void:
	if active:
		#top_level = true
		scale = base_scale * (1.0 + hover_scale)
	else:
		#top_level = false
		scale = base_scale


func _on_mouse_entered() -> void:
	if interaction_mode:
		hovered.emit(self, true)
		
		blow_up(true)


func _on_mouse_exited() -> void:
	if interaction_mode:
		hovered.emit(self, false)
		blow_up(false)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	#print(interaction_mode)
	#if interaction_mode:
	in_play_area = true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	#if interaction_mode and check_for_play_area:
	if check_for_play_area:
		in_play_area = false
