extends Node
class_name DefenseComponent

signal dodged_attack # for visual feedback

@export var debug_mode: bool = false

@export_range(0, 1, 0.01) var dodge_chance: float = 0.0 
@export var flat_armor: float = 0.0

#@export var armor: float = 0.0

func modify_damage(damage: float) -> float:
	var dodge: float = randf_range(0, 1)
	if dodge <= dodge_chance:
		dodged_attack.emit()
		if debug_mode: print("%s dodged attack with: %f.2 <= %f.2" % [owner.name, dodge, dodge_chance])
		return 0
		
	damage = max(0, damage-flat_armor)
		
	#damage = max(0, damage-damage*armor)
	
	return damage
