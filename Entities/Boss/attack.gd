extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

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


func exit() -> void: 
	extra_info_label.hide()
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	extra_info_label.text = "%.2f" % attack_timer.time_left
	
func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	Transitioned.emit(self, "follow")
