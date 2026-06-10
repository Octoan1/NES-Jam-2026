extends CharacterBody2D


var player_facing = 1

#Siblings
@onready var sprite := $AnimatedSprite2D
@onready var attack_pivot := $AttackPivot
@onready var sword_hitbox := $AttackPivot/SwordHitbox
@onready var dash_timer := $DashTimer
@onready var dash_delay_timer := $DashDelayTimer

#Attack Variables
@export var attack_duration: float = 0.15
@export var attack_delay: float = 0.2
var can_attack: bool = true

#Dash Variables
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.1
@export var dash_delay: float = 0.5
var is_dashing: bool = false
var can_dash: bool = true
var waiting_to_land: bool = false

#Player Stats
@export var dmg: float = 2.0
#@export var health: int = 10
@export var gravity_modifier: float = 0.2
@export var speed: float = 200.0
@export var dodge_chance: float = 0.0
@export var jump_velocity: float = -125
var can_move: bool = true
var previous_location: Vector2

# coyote time
@export var coyote_time := 0.1
var coyote_timer := 0.0

# Components
@onready var health_component: HealthComponent = $HealthComponent

#Interaction
var can_interact: bool = false

#Climbing
@export var climb_speed: float = 50.0
var is_climbing: bool = false


func _ready() -> void:
	attack_pivot.visible = false
	sword_hitbox.monitoring = false 
	
	health_component.died.connect(die)
	previous_location = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and is_climbing:
		velocity.y = climb_speed
	elif not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
		coyote_timer -= delta
	else: 
		coyote_timer = coyote_time
	
	if waiting_to_land and is_on_floor() and dash_timer.is_stopped():
		is_dashing = false
		health_component.is_invulnerable = false
		sprite.play("default")
		dash_delay_timer.wait_time = dash_delay
		dash_delay_timer.start()
	
	if is_dashing:
		velocity.x = player_facing * dash_speed
		move_and_slide()
		return
	
	#Handles Climbing
	if can_interact and Input.is_action_pressed("D_Pad_Up") and not is_on_floor():
		velocity.y = -1 * climb_speed
		is_climbing = true
	elif not can_interact:
		is_climbing = false
		

	# Handle jump.
	if Input.is_action_just_pressed("A_Button") and (is_on_floor() or coyote_timer > 0.0) and not is_dashing and not is_climbing and can_move and not Input.is_action_pressed("D_Pad_Down"):
		velocity.y = jump_velocity
		coyote_timer = 0.0
		if Input.is_action_pressed("D_Pad_Up") and not is_climbing and can_dash:
			_start_dash()
			return

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("D_Pad_Left", "D_Pad_Right")
	if direction and can_move:
		velocity.x = direction * speed
		sprite.play("walk")
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
		player_facing = sign(direction)
		attack_pivot.scale.x = player_facing
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if Input.is_action_pressed("D_Pad_Down") and not is_climbing:
			sprite.play("duck")
		else:
			sprite.play("default")
	
	#Handle Dash
	#if Input.is_action_just_pressed("D_Pad_Down") and can_dash and is_on_floor():
	if Input.is_action_pressed("D_Pad_Down") and Input.is_action_just_pressed("A_Button") and can_dash and is_on_floor():
		_start_dash()

	
	#Handle Attack
	if Input.is_action_just_pressed("B_Button") and sword_hitbox.monitoring == false and can_attack and not is_climbing:
		_trigger_attack()
	
	previous_location = global_position
	move_and_slide()
	

func _trigger_attack() -> void:
	attack_pivot.visible = true
	sword_hitbox.monitoring = true
	
	can_move = false
	
	await get_tree().create_timer(attack_duration).timeout
	
	attack_pivot.visible = false
	sword_hitbox.monitoring = false	
	
	can_move = true
	
	#Delay after attack but before next attack
	can_attack = false
	
	await get_tree().create_timer(attack_delay).timeout
	
	can_attack = true
	
	
func _start_dash() -> void:
	is_dashing = true
	can_dash = false
	health_component.is_invulnerable = true
	sprite.play("roll")
	
	dash_timer.wait_time = dash_duration
	dash_timer.start()

func _on_dash_timer_timeout() -> void:
	dash_timer.stop()
	if is_on_floor():
		is_dashing = false
		health_component.is_invulnerable = false
		sprite.play("default")
		dash_delay_timer.wait_time = dash_delay
		dash_delay_timer.start()
	else:
		waiting_to_land = true

#
#func player_take_damage(amount: int) -> void:
	#if randf() >= dodge_chance:
		#health -= amount
		#print("Player Health Remaining: ", health)
	#else:
		#print("Attack Dodged")
	#
	#if health <= 0:
		#die()

func die() -> void:
	pass


func _on_interactbox_component_body_entered(_body: Node2D) -> void:
	can_interact = true


func _on_interactbox_component_body_exited(_body: Node2D) -> void:
	can_interact = false


func _on_dash_delay_timer_timeout() -> void:
	dash_delay_timer.stop()
	can_dash = true
	waiting_to_land = false
