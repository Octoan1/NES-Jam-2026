extends CharacterBody2D

@export var SPEED: float = 100.0

var direction: Vector2
var spawn_pos: Vector2
var spawn_rot: float

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(direction.angle() - (PI / 2))
	move_and_slide()
