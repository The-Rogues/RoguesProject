extends MiniEventResult
class_name MultiResult

@export var outcomes: Array[MiniEventResult]

func resolve():
	for i in range(0, outcomes.size()):
		outcomes[i].resolve()
