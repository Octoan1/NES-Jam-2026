extends Area2D
class_name HitboxComponent

@export var debug_mode: bool = false

func _ready() -> void:
	self.monitoring = true
	self.monitorable = false
	
	area_entered.connect(_on_hitbox_component_area_entered)


func _on_hitbox_component_area_entered(area: Area2D) -> void: 
	if debug_mode:
		print(area.name + " - owned by: " + area.owner.name)
		
	# Check for Hurtbox
	if area is HurtboxComponent:
		var hurtbox : HurtboxComponent = area
		
		#var attack = Attack.new()
		#attack.attack_damage = 1
		var attack: float = 1.0
		
		hurtbox.hurt(attack)
