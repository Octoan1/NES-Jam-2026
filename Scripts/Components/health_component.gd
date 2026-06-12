extends Node
class_name HealthComponent

@export var debug_mode: bool = false

@export var max_health := 10
@export var invulnerability_duration := 0.5

@export var defense_component: DefenseComponent

var health: float
var is_invulnerable: bool = false
var invul_timer: Timer


signal died
signal damaged
signal health_changed(current_health: float, max_health: float)
signal invulnerability_started
signal invulnerability_ended

func _ready() -> void:
	health = max_health
	invul_timer = Timer.new()
	invul_timer.wait_time = invulnerability_duration
	self.add_child(invul_timer)
	invul_timer.timeout.connect(_on_invul_timer_timeout)
	
#func damage_health(attack: Attack):
func damage_health(attack_damage: float) -> bool:
	if is_invulnerable:
		if debug_mode:
			print(owner.name + " is invulnerable right now")
		return false
	
	if defense_component:
		attack_damage = defense_component.modify_damage(attack_damage)
		if attack_damage <= 0:
			return false
	
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
	return true
	
func start_invulnerability() -> void:
	is_invulnerable = true
	invulnerability_started.emit()
	invul_timer.start(invulnerability_duration)

func _on_invul_timer_timeout() -> void:
	invul_timer.stop()
	is_invulnerable = false
	invulnerability_ended.emit()
