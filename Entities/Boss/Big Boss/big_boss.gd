extends CharacterBody2D

enum State {
	ATTACKING,
	NORMAL
}

var state := State.NORMAL
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var player: CharacterBody2D
@onready var attack_pivot: Node2D = $AttackPivot
@onready var slash_hb: HitboxComponent = $AttackPivot/SlashHitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var room = $".."

@export var gravity_modifier: float = 0.6
@onready var stat_component: StatComponent = $StatComponent

signal Animation_Done

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	attack_pivot.visible = false
	slash_hb.monitoring = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _physics_process(_delta: float) -> void:
	if not player:
		player =  get_tree().get_first_node_in_group("Player")
	if state == State.NORMAL:
		var direction: int = sign(self.global_position.x - player.global_position.x)
		sprite_2d.flip_h = direction > 0
		attack_pivot.scale.x = direction
	
	move_and_slide()

func slash_attack() -> void:
	animation_player.play("slash_attack")

func _on_health_component_damaged() -> void:
	$HitSFX.play()

func _on_animation_finished(anim_name: StringName) -> void:
	Animation_Done.emit()
