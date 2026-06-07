extends CharacterBody2D

@export var health: int = 100
@export var dmg: int = 1

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy hit! Health remaining: ", health)
	
	if health <= 0:
		die()

func die() -> void:
	print("Enemy defeated!")
	health = 100


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_take_damage"):
		body.player_take_damage(dmg)
