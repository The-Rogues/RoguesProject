extends Resource
class_name PersonalityData
## Resource that stores personality traits and functions for resolving targets
## and movement direction.
##
## Intended to be used as a creatable asset by a character creator script
## that stores it's instance in a persistent manner.

signal updated_offensive_trait(_trait:PersonalityTrait, weight:int)
signal updated_defensive_trait(_trait:PersonalityTrait, weight:int)
signal updated_strategic_trait(_trait:PersonalityTrait, weight:int)
signal updated_priority_trait(_trait:PersonalityTrait)
signal updated(personality:PersonalityData)

## Influences capacity and attitude towards violence.
@export var offensive_trait:PersonalityTrait
## Controls how much the offensive trait is priotized over other traits.
@export var offensive_weight:int
## Influences capacity and attitude towards self-preservation.
@export var defensive_trait:PersonalityTrait
## Controls how much the defensive trait is priotized over other traits.
@export var defensive_weight:int
## Supplimentary motivation for other natures.
@export var strategic_trait:PersonalityTrait
## Controls how much the strategic trait is priotized over other traits.
@export var strategic_weight:int

@export var priority_trait:PersonalityTrait = null

const MINIMUM_WEIGHT = 1
const MAXIMUM_WEIGHT = 10


func initialize(
		_offensive_trait:PersonalityTrait,
		_defensive_trait:PersonalityTrait,
		_strategic_trait:PersonalityTrait,
		_priority_trait:String
) -> void:
	offensive_trait = _offensive_trait
	defensive_trait = _defensive_trait
	strategic_trait = _strategic_trait
	
	offensive_weight = 1
	defensive_weight = 1
	strategic_weight = 1
	
	var trait_category = _priority_trait.to_upper()
	
	if trait_category == "OFFENSIVE":
		priority_trait = offensive_trait
		offensive_weight = 2
	elif trait_category == "DEFENSIVE":
		priority_trait = defensive_trait
		defensive_weight = 2
	elif trait_category == "STRATEGIC":
		priority_trait = strategic_trait
		strategic_weight = 2

func choose_move_direction(
	left_idx: int, 
	right_idx: int, 
	positions: Array[BattlePosition],
	in_offensive: int,
	in_defensive: int,
	in_strategic: int
) -> bool:
	var priority_order: Array[int] = create_trait_order(
		in_offensive,
		in_defensive,
		in_strategic
	)
	
	for i in range(0, priority_order.size()):
		var targeting_option: ObjectData.MoveTargetingCategory
		match priority_order[i]:
			0:
				targeting_option = offensive_trait.object_targeting_preference
			1:
				targeting_option = defensive_trait.object_targeting_preference
			2:
				targeting_option = strategic_trait.object_targeting_preference
		var object_exists: bool = false
		for j in range(0, positions.size()):
			var curr_obj: ObjectEntity = positions[j].get_object()
			if curr_obj == null:
				continue
			elif curr_obj.data.targeting_categories.has(targeting_option):
				object_exists = true
				break
		if !object_exists:
			continue
		var dist_left: int = dist_from_preferred(left_idx, targeting_option, positions)
		var dist_right: int = dist_from_preferred(right_idx, targeting_option, positions)
		if dist_left == dist_right:
			if randf() < 0.5:
				return false
			return true
		elif dist_left < dist_right:
			return false
		else:
			return true
	if randf() < 0.5:
		return false
	return true

func dist_from_preferred(
	in_idx: int, 
	in_targeting: ObjectData.MoveTargetingCategory, 
	in_positions: Array[BattlePosition]
) -> int:
	var ret_val: int = 10
	for i in range(in_idx, in_positions.size()):
		if in_positions[i].get_object() != null:
			if in_positions[i].get_object().data.targeting_categories.has(in_targeting):
				if ret_val > (i - in_idx):
					ret_val = i - in_idx
					break
	for i in range(in_idx - 1, -1, -1):
		if in_positions[i].get_object() != null:
			if in_positions[i].get_object().data.targeting_categories.has(in_targeting):
				if ret_val > (in_idx - i):
					ret_val = in_idx - i
				elif (in_idx - i) >= ret_val:
					break
	return ret_val

func choose_object_target(
	objects: Array[ObjectEntity],
	in_offensive: int,
	in_defensive: int,
	in_strategic: int
) -> ObjectEntity:
	
	var priority_order: Array[int] = create_trait_order(
		in_offensive,
		in_defensive,
		in_strategic
	)
	
	for i in range(0, priority_order.size()):
		var targeting_option: ObjectData.MoveTargetingCategory
		match priority_order[i]:
			0:
				targeting_option = offensive_trait.object_targeting_preference
			1:
				targeting_option = defensive_trait.object_targeting_preference
			2:
				targeting_option = strategic_trait.object_targeting_preference
		var filtered_objects: Array[ObjectEntity]
		for j in range(0, objects.size()):
			if objects[j].data.targeting_categories.has(targeting_option):
				filtered_objects.append(objects[j])
		if filtered_objects.size() > 0:
			return filtered_objects.pick_random()
	return objects.pick_random()

## Choosest the highest priority target given the biases of personality traits.
func choose_enemy_target(
	enemies:Array[MonsterEntity],
	in_offensive: int,
	in_defensive: int,
	in_strategic: int
) -> MonsterEntity:
	
	var priority_order: Array[int] = create_trait_order(
		in_offensive,
		in_defensive,
		in_strategic
	)
	
	for i in range(0, priority_order.size()):
		var targeting_option: MonsterData.AttackTargetingCategory
		match priority_order[i]:
			0:
				targeting_option = offensive_trait.enemy_targeting_preference
			1:
				targeting_option = defensive_trait.enemy_targeting_preference
			2:
				targeting_option = strategic_trait.enemy_targeting_preference
		var filtered_enemies: Array[MonsterEntity]
		for j in range(0, enemies.size()):
			if enemies[j].updated_targeting.has(targeting_option):
				filtered_enemies.append(enemies[j])
		if filtered_enemies.size() > 0:
			return filtered_enemies.pick_random()
	return enemies.pick_random()

# offense -> 0
# defense -> 1
# strategic -> 2
func create_trait_order(
	in_offensive: int,
	in_defensive: int,
	in_strategic: int
) -> Array[int]:
	
	var ret_val: Array[int] = []
	var i: int = 0
	while ret_val.size() < 3:
		ret_val = ret_val + get_highest_offset(
			i, 
			in_offensive, 
			in_defensive, 
			in_strategic
		)
		i = i + 1
	return ret_val


func get_highest_offset(
	highest_offset: int,
	in_offensive: int,
	in_defensive: int,
	in_strategic: int
) -> Array[int]:
	
	var prev_highest: int = 11
	var curr_highest: int = 0
	var ret_val: Array[int]
	
	for i in range(0, highest_offset + 1):
		if offensive_weight > curr_highest && in_offensive < prev_highest:
			curr_highest = in_offensive
		if defensive_weight > curr_highest && in_defensive < prev_highest:
			curr_highest = in_defensive
		if strategic_weight > curr_highest && in_strategic < prev_highest:
			curr_highest = in_strategic
		
		prev_highest = curr_highest
		curr_highest = 0
		
		if i == highest_offset:
			if offensive_weight == prev_highest:
				ret_val.append(0)
			if defensive_weight == prev_highest:
				ret_val.append(1)
			if strategic_weight == prev_highest:
				ret_val.append(2)
	
	return ret_val


func has_trait(_trait:String) -> bool:
	var trait_name:String = _trait.to_upper()
	
	if offensive_trait.name == trait_name:
		return true
	if defensive_trait.name == trait_name:
		return true
	if strategic_trait.name == trait_name:
		return true
	return false


func set_trait(trait_category:String, _trait:PersonalityTrait) -> void:
	match trait_category.to_upper():
		"OFFENSIVE":
			if offensive_trait !=  _trait:
				offensive_trait = _trait
				updated_offensive_trait.emit(offensive_trait, offensive_weight)
				updated.emit(self)
		"DEFENSIVE":
			if defensive_trait != _trait:
				defensive_trait = _trait
				updated_defensive_trait.emit(defensive_trait, defensive_weight)
				updated.emit(self)
		"STRATEGIC":
			if strategic_trait != _trait:
				strategic_trait = _trait
				updated_strategic_trait.emit(strategic_trait, strategic_weight)
				updated.emit(self)
		_:
			return
	
	update_priority_trait()


func set_trait_weight(trait_category:String, _weight:int) -> void:
	match trait_category.to_upper():
		"OFFENSIVE":
			offensive_weight = _weight
			offensive_weight = clampi(
					offensive_weight, 
					MINIMUM_WEIGHT, 
					MAXIMUM_WEIGHT)
			updated_offensive_trait.emit(offensive_trait, offensive_weight)
			updated.emit(self)
		"DEFENSIVE":
			defensive_weight = _weight
			defensive_weight = clampi(defensive_weight, 
					MINIMUM_WEIGHT, 
					MAXIMUM_WEIGHT)
			updated_defensive_trait.emit(defensive_trait, defensive_weight)
			updated.emit(self)
		"STRATEGIC":
			strategic_weight = _weight
			strategic_weight = clampi(strategic_weight, 
					MINIMUM_WEIGHT, 
					MAXIMUM_WEIGHT)
			updated_strategic_trait.emit(strategic_trait, strategic_weight)
			updated.emit(self)
		_:
			pass
	update_priority_trait()


func update_priority_trait() -> void:
	var _priority_trait:PersonalityTrait = strategic_trait
	if defensive_weight >= strategic_weight:
		priority_trait = defensive_trait
	if offensive_weight >= defensive_weight:
		priority_trait = offensive_trait
	
	if priority_trait != _priority_trait:
		priority_trait = _priority_trait
		updated_priority_trait.emit(priority_trait)
