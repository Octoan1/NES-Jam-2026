extends Area2D
class_name HitboxComponent

signal hit

@export var debug_mode: bool = false
@export var attack: Attack


func _ready() -> void:
	self.monitoring = true
	self.monitorable = false
	
	if not attack:
		attack = Attack.new()
	#area_entered.connect(_on_hitbox_component_area_entered)


func _physics_process(_delta: float) -> void:
	if not monitoring:
		return
	
	for area in get_overlapping_areas():
		if area is HurtboxComponent:	
			var hurtbox : HurtboxComponent = area
			
			if debug_mode:
				print(hurtbox.name + " - owned by: " + hurtbox.owner.name)
		
			hurtbox.hurt(attack)
		
			hit.emit()
			

#func _on_hitbox_component_area_entered(area: Area2D) -> void: 
	#if debug_mode:
		#print(area.name + " - owned by: " + area.owner.name)
		#
	## Check for Hurtbox
	#if area is HurtboxComponent:
		#var hurtbox : HurtboxComponent = area
		#
		##var attack = Attack.new()
		##attack.attack_damage = 1
		#var attack: float = 1.0
		#
		#hurtbox.hurt(attack)
		#
		#hit.emit()
