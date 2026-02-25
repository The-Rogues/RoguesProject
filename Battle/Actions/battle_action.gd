@abstract
extends Resource
class_name BattleAction
## Template class for atomic actions performed in a battle by cards and entities. 

## Virtual function that is scripted to perform an atomic action
@abstract
func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null)
