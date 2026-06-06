extends Node
class_name HealthComponent

@export var MAX_HEALTH := 10
var health : float

signal died
signal damaged

func _ready() -> void:
	health = MAX_HEALTH
	
#func remove_health(attack: Attack):
func attack_health(attack_damage: float) -> void:
	health -= attack_damage
	#print(owner.name + " health is now: "+ str(health))
	damaged.emit()
	
	# death 
	if health <= 0:
		#damaged.emit(attack.attack_damage)
		died.emit()
