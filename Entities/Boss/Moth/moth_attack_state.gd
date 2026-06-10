extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

@export var attack_delay: float = 2.0
@export var max_num_shots: int = 3
var num_shots: int

var delay_timer: Timer

func _ready() -> void:
	delay_timer = Timer.new()
	delay_timer.wait_time = attack_delay
	self.add_child(delay_timer)
	delay_timer.timeout.connect(_on_delay_timer_timeout)

func enter() -> void:
	extra_info_label.show()
	num_shots = 0
	if delay_timer.is_stopped():
		delay_timer.start()

func exit() -> void: 
	extra_info_label.hide()
	
func update(_delta: float) -> void:
	pass
	

func physics_update(_delta: float) -> void:
	pass

func _on_delay_timer_timeout() -> void:
	if num_shots == max_num_shots:
		delay_timer.stop()
		Transitioned.emit(self, "moth move")
	else:
		print("Moth Attacks")
		enemy.attack()
		num_shots += 1
		delay_timer.start()
