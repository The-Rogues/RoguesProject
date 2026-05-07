extends MiniEventResult
class_name EnterBattleResult

@export var encounter:EnemyEncounter

func get_result_text() -> String:
	return "You challenge the " + encounter.encounter_name


func resolve():
	GlobalSceneLoader.battle_builder.override_encounter = encounter
	GlobalSceneLoader.load_battle_scene()
