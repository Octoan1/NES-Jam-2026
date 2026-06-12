extends State

@export var debug_mode: bool = false

# state configurations
@export var attack_charge: float = 1.0
@export var attack_duration: float = 0.5

# node references
@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var revenge_hitbox: HitboxComponent = $"../../RevengeHitbox"
@onready var revenge_sprite: AnimatedSprite2D = $"../../RevengeSprite"

# state nodes
@onready var charge_timer: Timer
@onready var attack_timer: Timer

# local vars
var attacked_count: int

func _ready() -> void:
	revenge_hitbox.monitoring = false
	
	player = get_tree().get_first_node_in_group("Player")
	# create timer
	charge_timer = Timer.new()
	charge_timer.wait_time = attack_charge
	charge_timer.timeout.connect(_on_charge_timer_timeout)
	
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_duration
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	add_child(charge_timer)
	add_child(attack_timer)

func enter() -> void:
	if charge_timer.is_stopped():
		charge_timer.start()
	
func exit() -> void:
	attack_timer.stop()
	revenge_sprite.hide()
	revenge_hitbox.monitoring = false


func update(_delta: float) -> void:
	# Transitioned.emit(self, "new_state")
	pass

func _on_charge_timer_timeout() -> void:
	charge_timer.stop()
	revenge_hitbox.scale = Vector2.ZERO
	
	revenge_sprite.show()
	revenge_sprite.play("attack")
	revenge_hitbox.monitoring = true
	
	var tween = create_tween()
	
	tween.tween_property(revenge_hitbox, "scale", Vector2.ONE, attack_duration)
	#\.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	attack_selection()
	

func attack_selection():
	var attacks = ["BatAttack", "BloodAttack", "BloodRainAttack"]
	var attack_choice = attacks.pick_random()
	Transitioned.emit(self, attack_choice)
