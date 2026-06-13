extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

@export var attack_delay: float = 2.0

var delay_timer: Timer

func _ready() -> void:
	delay_timer = Timer.new()
	self.add_child(delay_timer)
	delay_timer.timeout.connect(_on_delay_timer_timeout)

func enter() -> void:
	extra_info_label.show()
	if delay_timer.is_stopped():
		delay_timer.start(attack_delay)
	enemy.state = enemy.State.ATTACKING
		

func exit() -> void: 
	extra_info_label.hide()
	enemy.state = enemy.State.NORMAL
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass

func _on_delay_timer_timeout() -> void:
	enemy.slash_attack()
	delay_timer.stop()

func _on_animation_finished() -> void:
	Transitioned.emit(self, "BigBossMove")
	
