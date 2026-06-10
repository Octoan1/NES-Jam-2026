extends State

@export var debug_mode: bool = false

# state configurations
@export var attack_delay: float = 1.0
@export var bullet_speed: float = 200
@export var revenge_threshold: int = 5
# scenes
@export var bullet_scene: PackedScene

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var bat_right: Marker2D = $"../../BatRight"
@onready var bat_left: Marker2D = $"../../BatLeft"

# state nodes
@onready var attack_timer: Timer

# local vars
var attack_count: int = 5
var current_count: int
var attacked_count: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	# create timer
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func enter() -> void:
	current_count = 0
	attacked_count = 0
	if attack_timer.is_stopped():
		attack_timer.start()
	
func exit() -> void:
	attack_timer.stop()


func update(_delta: float) -> void:
	# Transitioned.emit(self, "new_state")
	if current_count >= attack_count:
		attack_selection()
	if attacked_count >= revenge_threshold:
		Transitioned.emit(self, "RevengeAttack")

func _on_attack_timer_timeout() -> void:
	# create bullet
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.scale = Vector2(2, 2)
	#bullet.get_child(0).texture = bat_sprite
	
	if randi_range(0,1) == 0:
		bullet.global_position = bat_right.global_position
		bullet.target = bat_left.global_position
	else:
		bullet.global_position = bat_left.global_position
		bullet.target = bat_right.global_position
	bullet.move_speed = bullet_speed
	add_child(bullet)
	
	current_count += 1

func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack", "Rest"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)

func _on_health_component_damaged() -> void:
	attacked_count += 1
