extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D
@onready var jump_timer: Timer = $JumpTimer
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

@export var move_speed: float = 40


func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	extra_info_label.show()
	
func exit() -> void:
	extra_info_label.hide()

func physics_update(_delta: float) -> void:
	#move_direction = enemy.global_position.direction_to(player.global_position).x
	var move_direction: int = 1 if enemy.global_position < player.global_position else -1
	enemy.velocity.x = move_direction * move_speed
	
	var distance = player.global_position - enemy.global_position
	if abs(distance.x) < 25 and abs(distance.y) < 10:
		Transitioned.emit(self, "attack")
		
	
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
