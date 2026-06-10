extends State

@export var debug_mode: bool = false

# state configurations
@export var attack_delay: float = 1
@export var bullet_fire_delay = 0.2
@export var bullet_spawn_delay: float = 0.1
@export var bullet_speed: float = 100
@export var revenge_threshold: int = 5
# scenes
@export var bullet_scene: PackedScene

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var blood_projectile_spawns: Node2D = $"../../BloodProjectileSpawns"



# state nodes
@onready var attack_timer: Timer
@onready var spawn_timer: Timer

# local vars
var projectile_count: int = 5
var bullets = []
var attacked_count: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	

func enter() -> void:
	# add 5 projectiles, each with their unique spawn coords
	bullets = []
	attacked_count = 0
	
	for spawn in blood_projectile_spawns.get_children():
		print(spawn)
		var bullet: Node2D = bullet_scene.instantiate()
		bullet.global_position = spawn.global_position
		#bullet.target = player.global_position
		bullet.move_speed = 0
		bullets.append(bullet)
		
		await get_tree().create_timer(bullet_spawn_delay).timeout
		add_child(bullet)
	
	await get_tree().create_timer(attack_delay).timeout
	
	# after all have been spawned, fire them out one by one
	for i in range(projectile_count):
		print("fire!")
		bullets[i].direction = bullets[i].global_position.direction_to(player.global_position)
		bullets[i].move_speed = bullet_speed
		await get_tree().create_timer(bullet_fire_delay).timeout
	
	attack_selection()

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if attacked_count >= revenge_threshold:
		Transitioned.emit(self, "RevengeAttack")

func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack", "Rest"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)

func _on_health_component_damaged() -> void:
	attacked_count += 1
