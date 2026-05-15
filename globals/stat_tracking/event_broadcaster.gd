### event_broadcaster.gd
### global Events
extends Node


signal run_completed(summary:RunProgress)
#signal defeated_monster(monster:MonsterData, room:int)
signal used_personality_trait(_trait:String)
signal personality_changed(_trait:String, weight:int)
signal item_used(item:ItemData)
signal energy_used(amount:int)
signal chest_opened
signal friend_summoned(friend:Friend)
signal object_placed(object:ObjectData)
signal battle_won(encounter:EnemyEncounter, player_state:PlayerEntity)
signal gold_collected(amount:int)
signal card_collected(card:CardData)
signal turn_started(turn:int)
