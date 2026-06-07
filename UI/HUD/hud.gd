extends Control

@onready var health_container: HBoxContainer = $TextureRect/Control/HealthContainer

@export var heart_scene: PackedScene

var player: CharacterBody2D
var health_points: Array[TextureRect]

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.health_component.health_changed.connect(update_health)
	
	create_hearts(player.health_component.max_health)
	
	update_health(
		player.health_component.health,
		player.health_component.max_health
	)
	
	
func create_hearts(max_health: float) -> void:
	for child in health_container.get_children():
		child.queue_free()

	health_points.clear()

	for i in range(max_health):
		var heart: TextureRect = heart_scene.instantiate()

		health_container.add_child(heart)
		health_points.append(heart)
		
	
func update_health(current_health: float, max_health: float) -> void:
	if health_points.size() != max_health:
		create_hearts(max_health)

	for i in range(health_points.size()):
		health_points[i].visible = i < current_health
