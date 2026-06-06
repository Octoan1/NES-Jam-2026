extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent


func _ready() -> void:
	self.monitoring = false
	self.monitorable = true
	
	if not health_component:
		printerr("ERROR: HurtboxComponent missing HealthComponent on: " + owner.name)


#func hurt(attack: Attack):
func hurt(attack: float) -> void:
	if health_component:
		health_component.damage(attack)
