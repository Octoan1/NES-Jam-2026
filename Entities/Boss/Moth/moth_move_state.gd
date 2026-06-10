extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

var positions: Array[Vector2] = [Vector2(28, 168), Vector2(28, 120), Vector2(28, 72), Vector2(223, 168), Vector2(223, 120), Vector2(223, 72)]
var big_position: Vector2 = Vector2(126, 120)
var next_position: Vector2
@export var fly_speed: float = 100.0

var big_attack: bool = true

func randomize_position():
	var ran = randf()
	if big_attack or ran < 0.8:
		next_position = positions[randi_range(0, 5)]
		big_attack = false
	else:
		next_position = big_position
		big_attack = true

func enter() -> void:
	randomize_position()
	extra_info_label.show()

func exit() -> void: 
	enemy.velocity = Vector2.ZERO
	extra_info_label.hide()
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if enemy:
		#var direction = Vector2(enemy.global_position.x - next_position.x, enemy.global_position.y - next_position.y)
		enemy.velocity = Vector2(move_toward(enemy.global_position.x, next_position.x, fly_speed) - enemy.global_position.x, move_toward(enemy.global_position.y, next_position.y, fly_speed) - enemy.global_position.y)
		#enemy.velocity = Vector2(direction.x * fly_speed * delta, direction.y * fly_speed * delta)
		
		var distance = next_position - enemy.global_position
		if abs(distance.x) < 2 and abs(distance.y) < 2 and not big_attack:
			Transitioned.emit(self, "moth attack")
		elif abs(distance.x) < 2 and abs(distance.y) < 2 and big_attack:
			Transitioned.emit(self, "moth big attack")
