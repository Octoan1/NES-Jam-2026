extends CharacterBody2D

var gravity_modifier: float = 0.1

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
	
	move_and_slide()
