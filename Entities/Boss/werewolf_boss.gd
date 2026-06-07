extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash_component: FlashComponent = $FlashComponent

@export var gravity_modifier: float = 0.2

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
	
	move_and_slide()



func _on_health_component_damaged() -> void:
	$HitSFX.play()
