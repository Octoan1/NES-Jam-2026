extends State

@export var debug_mode: bool = false

@export var attack_delay: float = 0.5

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var attack_timer: Timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	add_child(attack_timer)

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
