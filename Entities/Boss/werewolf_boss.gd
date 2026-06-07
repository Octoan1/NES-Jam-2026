extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var gravity_modifier: float = 0.2

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
	
	move_and_slide()



func _on_health_component_damaged() -> void:
	flash_white()
	$HitSFX.play()
	
func flash_white() -> void:
	sprite_2d.material.set_shader_parameter("flash_amount", 1.0)
	
	await get_tree().create_timer(.2).timeout
	
	sprite_2d.material.set_shader_parameter("flash_amount", 0.0)
