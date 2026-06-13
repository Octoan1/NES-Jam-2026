extends State

@export var debug_mode: bool = false

# state configurations
@export var attack_delay: float = 0.1
@export var bullet_speed: float = 50
@export var revenge_threshold: int = 3
@export var projectile_count: int = 30
@export var attack_finish_delay: float = 3
# scenes
@export var bullet_scene: PackedScene

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var rain_left: Marker2D = $"../../RainLeft"
@onready var rain_right: Marker2D = $"../../RainRight"
@onready var stat_component: StatComponent = $"../../StatComponent"
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

# state nodes
@onready var attack_timer: Timer
@onready var spawn_timer: Timer
@onready var finish_timer: Timer

# local vars
var attacked_count: int
var current_count: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	# create timer
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	finish_timer = Timer.new()
	finish_timer.wait_time = attack_finish_delay
	finish_timer.timeout.connect(_on_finish_timer_timeout)
	
	add_child(attack_timer)
	add_child(finish_timer)

func enter() -> void:
	current_count = 0
	attacked_count = 0
	if attack_timer.is_stopped():
		attack_timer.start()
	sprite.play("blood_rain")
	
func exit() -> void:
	attack_timer.stop()
	finish_timer.stop()
	sprite.play("default")


func update(_delta: float) -> void:
	if attacked_count >= revenge_threshold:
		attack_timer.stop()
		Transitioned.emit(self, "RevengeAttack")

func _on_attack_timer_timeout() -> void:
	# create bullet
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.type = Bullet.BulletType.BLOOD_RAIN
	var bullet_x = randi_range(rain_left.global_position.x, rain_right.global_position.x)
	var bullet_y = rain_left.global_position.y
	bullet.global_position = Vector2(bullet_x, bullet_y)
	
	bullet.target = Vector2(bullet_x, bullet_y + 10)
	
	bullet.move_speed = bullet_speed
	bullet.get_child(1).stat_component = stat_component
	add_child(bullet)
	
	current_count += 1
	
	if current_count >= projectile_count:
		attack_timer.stop()
		finish_timer.start()
	

func _on_finish_timer_timeout() -> void:
	attack_selection()

func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack", "Rest"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)

# connect this
func _on_health_component_damaged() -> void:
	attacked_count += 1
