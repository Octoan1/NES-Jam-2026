extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

	var move_direction: int = 1 if enemy.global_position < player.global_position else -1
	
	enemy.velocity.x = move_direction * 30
	enemy.velocity.y = -120
	
func exit() -> void: 
	pass
	#enemy.gravity_modifier = 1
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
		
	if abs(enemy.velocity.y) < 10:
		Transitioned.emit(self, "follow")
