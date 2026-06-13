extends State

@export var debug_mode: bool = false

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var stat_component: StatComponent = $"../../StatComponent"

# Stats
@export var speed: float = 100.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func enter() -> void:
	pass
	
func exit() -> void:
	pass


func update(delta: float) -> void:
	if abs(player.global_position.x - enemy.global_position.x) > 40:
		var dir = sign(player.global_position.x - enemy.global_position.x)
		enemy.velocity.x = dir * speed * delta
	else:
		enemy.velocity.x = 0.0
		Transitioned.emit(self, "BigBossSlashAttack")
	
	
	
func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack", "Rest"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)
