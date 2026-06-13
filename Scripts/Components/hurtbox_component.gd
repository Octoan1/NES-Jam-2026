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


func hurt(attack: Attack, stats: StatComponent, attacker_pos: Vector2) -> void:
	if debug_mode:
		print(owner.name + " Hurtbox Hit")
	
	var damage_output = attack.attack_damage * stats.attack_mult
	var critical_roll = randf_range(0, 1)
	if critical_roll <= stats.crit_chance:
		damage_output *= stats.crit_mult
	elif stats.critical_fail == true:
		damage_output = 0

	if not health_component:
		return
		
	var did_damage = health_component.damage_health(damage_output)
	
	if not did_damage:
		return
		
	if entity and attack.knockback_force > 0.0:
		entity.apply_attack(attack, attacker_pos)
	
