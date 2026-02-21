@abstract
extends Resource
class_name BattleAction
## Resource that is a template for an atomic action that can be performed
## on in a battle by a [BattleEntity].
## 
## [BattleManager] is passed so that the action can access all relevent
## elements in a Battle scene. Such as all the enemies, the player, the card
## hand, battle positions, and heald items. The action-user is passed to easily
## access who executed the action, which so far can either be the player character
## or enemies.
## BattleAction's are designed to be modular, so instead of creating a child
## class called "Heal Attack", that heals the user and then deals damage to an
## enemy, create two seperate classes HealAction and DamageAction, which can
## perform their logic indipendently of eachother.

@abstract
func _execute(battle_instance:BattleManager, action_user:BattleEntity)
