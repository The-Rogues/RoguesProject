extends AbstractEntityData
class_name MonsterData

@export var move_sequences:Array[MoveSequence]
@export var behaviour:MonsterBehaviour

# Fletcher - Added the below enum for targeting.
enum AttackTargetingCategory {
	HEALTHIEST, # Calculated. Enemies that have the highest HP.
	WEAKEST, # Calculated. Enemies that have the lowest HP.
	DANGEROUS, # Calculated. Enemies that are attacking.
	INTELEGENT, # Calculated. Enemies taht are not directly attacking.
	IMBUED, # Calculated. Enemies with buffs or debuffs.
	SHINY, # Enemies that add treasure to battle rewards.
	INTIMIDATING, # Enemies that are scary.
	LEGENDARY # Powerful late-game enemies or rare enemies.
}

@export var init_targeting: Array[AttackTargetingCategory]
