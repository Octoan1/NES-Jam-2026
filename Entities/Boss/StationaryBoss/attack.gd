extends State

@export var debug_mode: bool = false

# state configurations
@export var attack_delay: float = 0.5
@export var bullet_speed: float = 20
# scenes
@export var bullet_scene: PackedScene

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
# state nodes
@onready var attack_timer: Timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	# create timer
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func enter() -> void:
	if attack_timer.is_stopped():
		attack_timer.start()
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func _on_attack_timer_timeout() -> void:
	# create bullet
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.global_position = enemy.global_position
	bullet.target = player.global_position
	bullet.move_speed = bullet_speed
	add_child(bullet)
	
	pass
