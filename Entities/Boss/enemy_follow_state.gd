extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

@export var move_speed: float = 40
var move_direction: Vector2


func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	move_direction = enemy.global_position.direction_to(player.global_position)
	
	enemy.velocity = move_direction * move_speed
	
