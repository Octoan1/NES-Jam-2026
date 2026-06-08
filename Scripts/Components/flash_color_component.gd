extends Node
class_name FlashComponent

@export var debug_mode: bool 

@export var sprite: Sprite2D
@export var health_component: HealthComponent


@export var color: Color = Color.WHITE
@export var flash_duration := 0.1

func _ready() -> void:
	# bandaid solution for spawning white
	flash()
	
	if not sprite:
		printerr("ERROR: missing sprite")
	
	if sprite.material is not ShaderMaterial:
		printerr("ERROR: sprite is missing correct shader")
	
	sprite.material.set_shader_parameter("flash_color", color)
	
	if not health_component:
		printerr("ERROR: missing HealthComponent")
	
	health_component.damaged.connect(flash)
	
	if debug_mode:
		print(owner.name, " flash listening to ", health_component.owner.name)

func flash() -> void:
	if debug_mode:
		print(owner.name + " flash ", color)
		
	sprite.material.set_shader_parameter("flash_amount", 1.0)
	await get_tree().create_timer(flash_duration).timeout
	sprite.material.set_shader_parameter("flash_amount", 0.0)
