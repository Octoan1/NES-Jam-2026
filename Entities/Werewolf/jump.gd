extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

@export var jump_delay: float = 0.5
@export var jump_velocity: Vector2 = Vector2(50, -250)

var has_jumped: bool = false

func enter() -> void:
	has_jumped = false
	player = get_tree().get_first_node_in_group("Player")

	await get_tree().create_timer(jump_delay).timeout

	var move_direction: int = 1 if enemy.global_position < player.global_position else -1
	enemy.velocity.x = move_direction * jump_velocity.x
	enemy.velocity.y = jump_velocity.y
	
	has_jumped = true
	
func exit() -> void: 
	pass
	#enemy.gravity_modifier = 1
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if has_jumped and enemy.is_on_floor() and enemy.velocity.y < 5:
		Transitioned.emit(self, "follow")
