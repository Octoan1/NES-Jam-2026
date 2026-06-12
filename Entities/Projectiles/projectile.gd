extends CharacterBody2D

#Stats
var SPEED: float = 175.0
var direction: Vector2
var spawn_pos: Vector2
var spawn_rot: float

#Fire Delay
var fire_delay: float
var delay_timer: Timer
var can_fire: bool = false

#Curve
var is_curve: bool
var turn_rate: float = 2.0
var max_turn: float = PI / 2
var turned: float = 0.0


func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot
	delay_timer = Timer.new()
	delay_timer.wait_time = fire_delay
	self.add_child(delay_timer)
	delay_timer.start()
	delay_timer.timeout.connect(_on_delay_timer_timeout)
	velocity = Vector2(0, -SPEED).rotated(direction.angle() - (PI / 2))

func _physics_process(delta: float) -> void:
	if can_fire:
		move_and_slide()
		if is_curve and abs(turned) < max_turn:
			var rotation_amount = turn_rate * delta
			velocity = velocity.rotated(rotation_amount)
			turned += rotation_amount

func _on_delay_timer_timeout() -> void:
	can_fire = true


func _on_despawn_component_body_entered(_body: Node2D) -> void:
	queue_free()
