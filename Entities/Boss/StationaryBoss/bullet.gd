extends Node2D

@export var target: Vector2
@export var move_speed: float

var direction: Vector2 

func _ready() -> void:
	direction = self.global_position.direction_to(target)

func _physics_process(delta: float) -> void:
	self.global_position += direction * move_speed * delta


func _on_hitbox_component_hit() -> void:
	$HitboxComponent.visible = false
	await get_tree().create_timer(.05).timeout
	$HitboxComponent.monitoring = false
	await get_tree().create_timer(.1).timeout
	queue_free()
