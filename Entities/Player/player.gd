extends CharacterBody2D


const JUMP_VELOCITY = -400.0

var player_facing = 1

#Siblings
@onready var sprite := $Sprite
@onready var attack_pivot := $AttackPivot
@onready var sword_hitbox := $AttackPivot/SwordHitBox/CollisionShape2D
@onready var dash_timer := $DashTimer

#Attack Variables
@export var  attack_duration: float = 0.15

#Dash Variables
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.1
var is_dashing: bool = false
var can_dash: bool = true

#Player Stats
@export var dmg: float = 2.0
@export var health: int = 10
@export var speed: float = 200.0
@export var dodge_chance: float = 0.0



func _ready() -> void:
	attack_pivot.visible = false
	sword_hitbox.disabled = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_dashing:
		velocity.x = player_facing * dash_speed
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("A_Button") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("D_Pad_Left", "D_Pad_Right")
	if direction:
		velocity.x = direction * speed
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
		attack_pivot.scale.x = direction
		player_facing = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#Handle Dash
	if Input.is_action_just_pressed("D_Pad_Down"):
		_start_dash()
	
	#Handle Attack
	if Input.is_action_just_pressed("B_Button") and sword_hitbox.disabled:
		_trigger_attack()

	move_and_slide()
	

func _trigger_attack() -> void:
	attack_pivot.visible = true
	sword_hitbox.disabled = false
	
	await get_tree().create_timer(attack_duration).timeout
	
	attack_pivot.visible = false
	sword_hitbox.disabled = true
	
func _start_dash() -> void:
	is_dashing = true
	can_dash = false
	
	dash_timer.wait_time = dash_duration
	dash_timer.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	
	await get_tree().create_timer(0.5).timeout
	can_dash = true


func _on_sword_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(dmg)

func player_take_damage(amount: int) -> void:
	if randf() >= dodge_chance:
		health -= amount
		print("Player Health Remaining: ", health)
	else:
		print("Attack Dodged")
	
	if health <= 0:
		die()

func die() -> void:
	pass
