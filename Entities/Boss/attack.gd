extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"
@onready var attack_pivot: Node2D = $"../../AttackPivot"
@onready var attack_hitbox: HitboxComponent = $"../../AttackPivot/AttackHitbox"

@export var attack_duration: float = 2.0
var attack_timer: Timer

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_duration
	self.add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func enter() -> void:
	enemy.velocity.x = 0
	extra_info_label.show()
	if attack_timer.is_stopped():
		attack_timer.start()
	attack_pivot.show()
	attack_hitbox.monitoring = true


func exit() -> void: 
	extra_info_label.hide()
	attack_pivot.hide()
	attack_hitbox.monitoring = false
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	extra_info_label.text = "%.2f" % attack_timer.time_left
	
func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	Transitioned.emit(self, "follow")
