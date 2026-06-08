extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

@export var move_speed: float = 40


func enter() -> void:
	pass
	
func exit() -> void:
	enemy.velocity.x = 0

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	# move to middle
	var move_direction: float = enemy.global_position.direction_to(Vector2i(128, 156)).x
	
	enemy.velocity.x = move_direction * move_speed
	
	# in middle
	print(enemy.global_position.distance_to(Vector2i(128, 156)))
	
	if enemy.global_position.distance_to(Vector2i(128, 156)) < 5:
		Transitioned.emit(self, "jump")
