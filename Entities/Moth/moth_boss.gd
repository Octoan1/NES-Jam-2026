extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var player: CharacterBody2D

@onready var room = $".."
@onready var projectile = load("res://Entities/Projectiles/projectile.tscn")

@export var gravity_modifier: float = 0.6

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(_delta: float) -> void:
	
	var direction: int = sign(self.global_position.x - player.global_position.x)
	sprite_2d.flip_h = direction > 0
	
	move_and_slide()

func attack() -> void:
	var instance = projectile.instantiate()
	var future_position = player.global_position + (player.global_position - player.previous_location)
	instance.direction = global_position - future_position
	instance.spawn_pos = global_position
	instance.spawn_rot = rotation
	instance.fire_delay = 0.01
	room.add_child.call_deferred(instance)

func big_attack() -> void:
	var directions = [Vector2.RIGHT, Vector2(0.5, -0.5), Vector2.UP, Vector2(-0.5, -0.5), Vector2.LEFT, Vector2(-0.5, 0.5), Vector2.DOWN, Vector2(0.5, 0.5)]
	for dir in directions:
		var instance = projectile.instantiate()
		instance.is_curve = true
		instance.direction = dir
		instance.spawn_pos = global_position - 10 * dir
		instance.spawn_rot = rotation
		instance.fire_delay = 1.0
		room.add_child.call_deferred(instance)

func _on_health_component_damaged() -> void:
	$HitSFX.play()
