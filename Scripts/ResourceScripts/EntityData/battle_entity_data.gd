# Author: Fabian

# An extension of entity data meant for BattleEntities (Player, Enemies)

extends EntityData
class_name BattleEntityData

# Additional stats for battle entities
# Amplifiers are multiply damage amounts and start at 1
# Configuration of these stats ensures amplifier is never zero so dealing
# and recieving damage is always possible
var defense_amplifier:Stat = Stat.new(2, 0.25, 1, false)
var attack_amplifier:Stat = Stat.new(2, 0.25, 1, false)
