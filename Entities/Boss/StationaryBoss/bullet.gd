extends Node2D
class_name Bullet

@export var target: Vector2
@export var move_speed: float
@export var type: BulletType = BulletType.DEFAULT
	
enum BulletType {DEFAULT, BAT, FIREBALL, BLOOD_RAIN}

var direction: Vector2 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	direction = self.global_position.direction_to(target)
	
	match type:
		BulletType.DEFAULT:
			animated_sprite_2d.play("default")
		BulletType.BAT:
			animated_sprite_2d.play("bat")
			$HitboxComponent.scale *= 2
		BulletType.FIREBALL:
			animated_sprite_2d.play("fireball")
		BulletType.BLOOD_RAIN:
			animated_sprite_2d.play("blood_rain")
			$HitboxComponent.scale = Vector2(.5, 1)

func _physics_process(delta: float) -> void:
	self.global_position += direction * move_speed * delta


func _on_hitbox_component_hit() -> void:
	$HitboxComponent.visible = false
	await get_tree().create_timer(.05).timeout
	$HitboxComponent.monitoring = false
	await get_tree().create_timer(.1).timeout
	queue_free()
