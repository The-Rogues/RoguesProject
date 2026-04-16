extends PanelContainer
class_name IntentToolTip

@onready var tool_tip_label: RichTextLabel = $ToolTipLabel


func initialize(intent:EnemyMove, monster:MonsterEntity):
	var path = intent.intent_icon.resource_path
	var _name = intent.name
	
	var header = "[color=gold]" + _name + "[/color][img]" + path + "[/img]\n"
	tool_tip_label.text = header + parse_intent_desciption(
			intent.description,
			monster)


func parse_intent_desciption(
		base_description:String,
		monster:MonsterEntity) -> String:
	
	var attack_regex:RegEx = RegEx.new()
	attack_regex.compile("get_atk\\d+")
	
	var matches = attack_regex.search_all(base_description)
	if matches.is_empty():
		return base_description
	
	var result_string = base_description
	var offset = 0
	
	for _match in matches:
		var start = _match.get_start() + offset
		var end = _match.get_end() + offset
		
		var number:int = get_string_number(_match)
		
		if monster:
			number = monster.effects.apply_attack_damage_effects(number)
		
		var replacement = str(number)
		
		result_string = (
			result_string.substr(0, start) +
			replacement +
			result_string.substr(end)
		)
		
		# adjust offset because string length may change
		offset += replacement.length() - (end - start)
	
	return result_string


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
