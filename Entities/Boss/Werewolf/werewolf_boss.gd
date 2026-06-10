extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var player: CharacterBody2D
@onready var attack_pivot: Node2D = $AttackPivot

@export var gravity_modifier: float = 0.6

var move_direction: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
	
	#var direction: int = sign(self.velocity.x)
	sprite_2d.flip_h = move_direction < 0
	attack_pivot.scale.x = move_direction
	
	move_and_slide()



func _on_health_component_damaged() -> void:
	$HitSFX.play()
