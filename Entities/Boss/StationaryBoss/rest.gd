extends State

@export var debug_mode: bool = false

# state configurations
@export var rest_length: float = 5.0
@export var revenge_threshold: int = 5


# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

# state nodes
@onready var rest_timer: Timer

# local vars
var attacked_count: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	# create timer
	rest_timer = Timer.new()
	rest_timer.wait_time = rest_length
	rest_timer.timeout.connect(_on_rest_timer_timeout)
	add_child(rest_timer)

func enter() -> void:
	attacked_count = 0
	if rest_timer.is_stopped():
		rest_timer.start()
	sprite.play("rest")
	
func exit() -> void:
	rest_timer.stop()
	sprite.play("default")
	pass


func update(_delta: float) -> void:
	# Transitioned.emit(self, "new_state")
	if attacked_count >= revenge_threshold:
		Transitioned.emit(self, "RevengeAttack")

func _on_rest_timer_timeout() -> void:
	var attack_choice = randi_range(0, 2)
	if attack_choice == 0:
		#Transitioned.emit(self, "bat_attack")
		pass
	elif attack_choice == 1:
		#Transitioned.emit(self, "blood_attack")
		pass
	
	attack_selection()
	

func _on_health_component_damaged() -> void:
	attacked_count += 1

func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)
