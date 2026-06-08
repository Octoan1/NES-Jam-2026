extends Node
class_name HealthComponent

@export var debug_mode: bool = false

@export var max_health := 10
@export var invulnerability_duration := 0.5

@export var defense_component: DefenseComponent

var health: float
var is_invulnerable: bool = false


signal died
signal damaged
signal health_changed(current_health: float, max_health: float)

func _ready() -> void:
	health = max_health
	
#func damage_health(attack: Attack):
func damage_health(attack_damage: float) -> void:
	if is_invulnerable:
		if debug_mode:
			print(owner.name + " is invulnerable right now")
		return
	
	if defense_component:
		attack_damage = defense_component.modify_damage(attack_damage)
		if attack_damage <= 0:
			return
	
	health -= attack_damage
	
	if debug_mode:
		print(owner.name + " health is now: "+ str(health))
		
	damaged.emit()
	health_changed.emit(health, max_health)
	
	# death 
	if health <= 0:
		#damaged.emit(attack.attack_damage)
		died.emit()
	
	if invulnerability_duration > 0:
		start_invulnerability()
	
func start_invulnerability() -> void:
	is_invulnerable = true
	await get_tree().create_timer(invulnerability_duration).timeout
	is_invulnerable = false
