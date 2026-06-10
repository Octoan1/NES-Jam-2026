extends CharacterBody2D

@export var SPEED: float = 100.0

var direction: Vector2
var spawn_pos: Vector2
var spawn_rot: float

var fire_delay: float
var delay_timer: Timer

var fire: bool = false

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot
	delay_timer = Timer.new()
	delay_timer.wait_time = fire_delay
	self.add_child(delay_timer)
	delay_timer.start()
	delay_timer.timeout.connect(_on_delay_timer_timeout)

func _physics_process(_delta: float) -> void:
	print(delay_timer.time_left)
	if fire:
		velocity = Vector2(0, -SPEED).rotated(direction.angle() - (PI / 2))
		move_and_slide()

func _on_delay_timer_timeout() -> void:
	fire = true
