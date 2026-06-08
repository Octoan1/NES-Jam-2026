extends Node2D


func _on_hitbox_component_hit() -> void:
	queue_free()
