extends Area2D
class_name HurtboxComponent

@export var debug_mode: bool = false

@export var health_component : HealthComponent


func _ready() -> void:
	self.monitoring = false
	self.monitorable = true
	
	if not health_component:
		printerr("ERROR: HurtboxComponent missing HealthComponent on: " + owner.name)


#func hurt(attack: Attack):
func hurt(attack: Attack, stats: StatComponent) -> void:
	if debug_mode:
		print(owner.name + " Hurtbox Hit")
	
	var damage_output = attack.attack_damage * stats.attack_mult
	
	var critical_roll = randf_range(0, 1)
	if critical_roll <= stats.crit_chance:
		damage_output *= stats.crit_mult
	elif stats.critical_fail == true:
		damage_output = 0
	
	
	if health_component:
		health_component.damage_health(damage_output)
