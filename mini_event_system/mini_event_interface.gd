extends Control

@onready var event_text_label = %EventTextLabel
@onready var option_1: Button = %Option1
@onready var option_2: Button = %Option2
@onready var next: Button = %Next
@onready var end: Button = %End
@onready var display_image: TextureRect = %DisplayImage

var current_event: MiniEventData
var main_event_callback
var event_progress := 0
var branch: Array[String] = []
var result_text := ""
var pending_result: MiniEventResult = null

func initialize(data: EventData):
	main_event_callback = data.main_event.event_callback.new()
	current_event = data.mini_event
	display_image.texture = current_event.display_image
	
	option_1.text = current_event.option_1_text
	option_2.text = current_event.option_2_text
	
	event_text_label.say(current_event.scenario_text)
	_apply_conditions()
	
	option_1.button_up.connect(_on_option_1, CONNECT_ONE_SHOT)
	option_2.button_up.connect(_on_option_2, CONNECT_ONE_SHOT)
	next.button_up.connect(progress_branch)
	end.button_up.connect(_on_end)


func _apply_conditions():
	if current_event.option_1_condition and not current_event.option_1_condition.is_met():
		option_1.disabled = true
		
	if current_event.option_2_condition and not current_event.option_2_condition.is_met():
		option_2.disabled = true


func _on_option_1():
	branch = current_event.option_1_branch.duplicate()
	pending_result = current_event.option_1_result
	_start_option(current_event.option_1_accept_event)


func _on_option_2():
	branch = current_event.option_2_branch.duplicate()
	pending_result = current_event.option_2_result
	_start_option(current_event.option_2_accept_event)


func _start_option(result: MiniEventResult):
	option_1.visible = false
	option_2.visible = false
	next.visible = true
	end.visible = false
	
	event_progress = 0
	
	if result:
		result.resolve()
	
	progress_branch()


func progress_branch():
	# If we've reached the end of the branch
	if event_progress >= branch.size():
		
		# Trigger final result ONCE
		if pending_result:
			pending_result.resolve()
			
			var text := pending_result.get_result_text()
			pending_result = null  # prevent double trigger
			
			if text != "":
				branch.append(text)
			
			next.visible = false
			end.visible = true
		else:
			# No more content, show end
			next.visible = false
			end.visible = true
	
	event_text_label.say(branch[event_progress])
	event_progress += 1
	
	if event_progress >= branch.size() and !pending_result:
		next.visible = false
		end.visible = true


func _on_end():
	queue_free()
	main_event_callback.process_event()
