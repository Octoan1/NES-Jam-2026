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
func hurt(attack: Attack, attacker_pos: Vector2) -> void:
	if debug_mode:
		print(owner.name + " Hurtbox Hit")
	
	if not health_component:
		return
		
	var did_damage = health_component.damage_health(attack.attack_damage)
	
	if not did_damage:
		return  # <-- CRITICAL
		
	if entity and attack.knockback_force > 0.0:
		entity.apply_attack(attack, attacker_pos)
	
