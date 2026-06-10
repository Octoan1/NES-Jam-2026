extends Resource
class_name Attack

@export var attack_damage: float
@export var knockback_force: float
#@export var attack_position: Vector2

func _init() -> void:
	attack_damage = 1
