extends CharacterBody2D

#States
enum State {
	NORMAL,
	HITSTUN,
	ATTACK,
	DASH,
	CLIMB
}
var state = State.NORMAL

var player_facing = 1

#Siblings
@onready var sprite := $AnimatedSprite2D
@onready var attack_pivot := $AttackPivot
@onready var sword_hitbox := $AttackPivot/SwordHitbox
@onready var dash_timer := $DashTimer
@onready var dash_delay_timer: Timer = $DashDelayTimer
@onready var health_component: HealthComponent = $HealthComponent

#Attack Variables
@export var attack_duration: float = 0.15
@export var attack_delay: float = 0.2
var can_attack: bool = true

#Dash Variables
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.1
@export var dash_delay: float = 0.5
var is_dashing: bool = false
var dash_locked: bool = false

#Player Stats
@export var dmg: float = 2.0
#@export var health: int = 10
@export var gravity_modifier: float = 0.2
@export var speed: float = 200.0
@export var dodge_chance: float = 0.0
@export var jump_velocity: float = -125
var can_move: bool = true
var previous_location: Vector2
var flashing := false

# coyote time
@export var coyote_time := 0.1
var coyote_timer := 0.0

#Interaction
var can_interact: bool = false

#Climbing
@export var climb_speed: float = 50.0
var is_climbing: bool = false

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 100.0


func _ready() -> void:
	attack_pivot.visible = false
	sword_hitbox.monitoring = false 
	
	health_component.died.connect(die)
	previous_location = global_position
	
	health_component.invulnerability_started.connect(_on_invuln_start)
	health_component.invulnerability_ended.connect(_on_invuln_end)
	dash_delay_timer.stop()

func _physics_process(delta: float) -> void:
	if state == State.HITSTUN:
		velocity.x = knockback_velocity.x
		velocity.y += get_gravity().y * delta * gravity_modifier
		
		#knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
		
		move_and_slide()
		
		if is_on_floor():
			state = State.NORMAL
			knockback_velocity = Vector2.ZERO
		return
	
	
	# Add the gravity.
	if not is_on_floor() and is_climbing:
		velocity.y = climb_speed
	elif not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
		coyote_timer -= delta
	else: 
		coyote_timer = coyote_time
	
	if dash_locked and is_on_floor() and dash_timer.is_stopped() and dash_delay_timer.is_stopped():
		_unlock_dash()
	
	if is_dashing:
		velocity.x = player_facing * dash_speed
		move_and_slide()
		return
	
	#Handles Climbing
	if can_interact and Input.is_action_pressed("D_Pad_Up") and not is_dashing:
		velocity.y = -1 * climb_speed
		is_climbing = true
	elif not can_interact:
		is_climbing = false
		

	# Handle jump.
	if Input.is_action_just_pressed("A_Button") and (is_on_floor() or coyote_timer > 0.0) and not is_dashing and not is_climbing and can_move and not Input.is_action_pressed("D_Pad_Down"):
		# trying to dash + jump
		if Input.is_action_pressed("D_Pad_Up"):
			if not is_climbing and not dash_locked:
				_start_dash()
				velocity.y = jump_velocity
				coyote_timer = 0.0
				return
			else:
				return
		
		# if not trying to dash, then jump normally
		velocity.y = jump_velocity
		coyote_timer = 0.0
		if Input.is_action_pressed("D_Pad_Up") and not is_climbing and not dash_locked:
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
	if Input.is_action_pressed("D_Pad_Down") and Input.is_action_just_pressed("A_Button") and not dash_locked and is_on_floor():
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
	dash_locked = true
	health_component.is_invulnerable = true
	sprite.play("roll")
	
	dash_timer.start(dash_duration)

func _on_dash_timer_timeout() -> void:
	dash_timer.stop()
	if is_on_floor():
		_unlock_dash()
	else:
		pass
	
func _unlock_dash():
	if not dash_locked:
		return
		
	is_dashing = false
	health_component.is_invulnerable = false
	sprite.play("default")
	dash_delay_timer.start(dash_delay)

func _on_dash_delay_timer_timeout() -> void:
	dash_delay_timer.stop()
	dash_locked = false

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
	
func apply_attack(attack: Attack, attacker_pos: Vector2):
	state = State.HITSTUN
	var dir = (global_position - attacker_pos).normalized()
	knockback_velocity = Vector2(
		sign(dir.x) * attack.knockback_force,
		attack.knockback_force * -0.5  # upward launch feel
	)
	velocity.y = knockback_velocity.y

func _on_invuln_start():
	flashing = true
	_flash_loop()

func _on_invuln_end():
	flashing = false
	sprite.modulate.a = 1.0

func _flash_loop() -> void:
	while flashing:
		sprite.modulate.a = 0.0
		await get_tree().create_timer(0.1).timeout

		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
