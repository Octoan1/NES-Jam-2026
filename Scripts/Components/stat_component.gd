extends Node
class_name StatComponent

@export var attack_mult: int = 1
@export var crit_mult: int = 0
@export_range(0, 1, 0.01) var crit_chance: float = 0.0
@export var critical_fail: bool = false
