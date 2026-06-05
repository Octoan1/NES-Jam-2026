extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#Siblings
@onready var sprite := $Sprite
@onready var attack_pivot := $AttackPivot
@onready var sword_hitbox := $AttackPivot/SwordHitBox/CollisionShape2D

#Attack Variables
@export var  attack_duration: float = 0.15


func _ready() -> void:
	attack_pivot.visible = false
	sword_hitbox.disabled = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("A_Button") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("D_Pad_Left", "D_Pad_Right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.flip_h = true
		elif direction < 0:
			sprite.flip_h = false
		attack_pivot.scale.x = direction * -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("B_Button") and sword_hitbox.disabled:
		_trigger_attack()

	move_and_slide()
	

func _trigger_attack() -> void:
	attack_pivot.visible = true
	sword_hitbox.disabled = false
	
	await get_tree().create_timer(attack_duration).timeout
	
	attack_pivot.visible = false
	sword_hitbox.disabled = true
