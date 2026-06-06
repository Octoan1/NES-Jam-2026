extends Node
class_name HealthComponent

@export var debug_mode: bool = false

@export var MAX_HEALTH := 10
var health : float

signal died
signal damaged

func _ready() -> void:
	health = MAX_HEALTH
	
#func remove_health(attack: Attack):
func attack_health(attack_damage: float) -> void:
	health -= attack_damage
	
	if debug_mode:
		print(owner.name + " health is now: "+ str(health))
		
	damaged.emit()
	
	# death 
	if health <= 0:
		#damaged.emit(attack.attack_damage)
		died.emit()
