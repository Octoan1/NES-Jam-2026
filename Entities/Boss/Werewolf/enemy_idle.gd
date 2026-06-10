extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var test: Timer = $Test


@export var move_speed: float = 40
var move_direction: int = 1

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func enter() -> void:
	test.start()
	
func exit() -> void:
	test.stop()

func physics_update(_delta: float) -> void:
	enemy.velocity.x = move_direction * move_speed
	



func _on_test_timeout() -> void:
	print("timeoutd")
	move_direction *= -1
