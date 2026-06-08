extends State

@onready var enemy: CharacterBody2D = $"../.."
@onready var extra_info_label: Label = $"../../DebugStateLabel/ExtraStateInfo"

var positions: Array[Vector2] = [Vector2(28, 168), Vector2(28, 120), Vector2(28, 72), Vector2(223, 168), Vector2(223, 120), Vector2(223, 72)]
var next_position: Vector2
@export var fly_speed: float = 200.0

func randomize_position():
	next_position = positions[randi_range(0, 5)]
	print(next_position)

func enter() -> void:
	randomize_position()
	extra_info_label.show()

func exit() -> void: 
	extra_info_label.hide()
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if enemy:
		print(enemy.global_position)
		enemy.velocity = Vector2(move_toward(enemy.global_position.x, next_position.x, fly_speed) - enemy.global_position.x, move_toward(enemy.global_position.y, next_position.y, fly_speed) - enemy.global_position.y)
		
		var distance = next_position - enemy.global_position
		if abs(distance.x) < 2 and abs(distance.y) < 2:
			print("CHEESECHEESECHEESE")
			Transitioned.emit(self, "moth attack")
