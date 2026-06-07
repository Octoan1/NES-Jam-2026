extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var jump_timer: Timer = $JumpTimer
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

@export var move_speed: float = 40
var move_direction: float


func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	move_direction = enemy.global_position.direction_to(player.global_position).x

	enemy.velocity.x = move_direction * move_speed
	if player.global_position.y < 120 and enemy.global_position.y > 120:
		if jump_timer.is_stopped():
			jump_timer.start()
	else:
		jump_timer.stop()
		
	extra_info_label.text = "%.2f" % jump_timer.time_left


func _on_jump_timer_timeout() -> void:
	jump_timer.stop()
	extra_info_label.text = ""
	
	Transitioned.emit(self, "preparejump")
