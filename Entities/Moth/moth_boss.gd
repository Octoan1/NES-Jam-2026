extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var player: CharacterBody2D

@export var gravity_modifier: float = 0.6

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(_delta: float) -> void:
	
	var direction: int = sign(self.velocity.x)
	sprite_2d.flip_h = direction < 0
	
	move_and_slide()


func _on_health_component_damaged() -> void:
	$HitSFX.play()
