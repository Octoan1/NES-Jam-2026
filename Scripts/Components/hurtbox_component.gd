extends Area2D
class_name HurtboxComponent

@export var debug_mode: bool = false

@export var health_component : HealthComponent
@onready var entity := $".."


func _ready() -> void:
	self.monitoring = false
	self.monitorable = true
	
	if not health_component:
		printerr("ERROR: HurtboxComponent missing HealthComponent on: " + owner.name)


#func hurt(attack: Attack):
func hurt(attack: Attack) -> void:
	if debug_mode:
		print(owner.name + " Hurtbox Hit")
	
	if health_component:
		health_component.damage_health(attack.attack_damage)
	
	if entity:
		print(attack.knockback_force)
		entity.velocity += Vector2(0.8, -0.2) * attack.knockback_force
	
