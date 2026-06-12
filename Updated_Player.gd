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

#Components
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_pivot := $AttackPivot
@onready var sword_hitbox := $AttackPivot/SwordHitbox
@onready var dash_timer := $DashTimer
@onready var dash_delay_timer: Timer = $DashDelayTimer
@onready var health_component: HealthComponent = $HealthComponent

#Attack Variables
@export var attack_duration: float = 0.15
@export var attack_delay: float = 0.2
var attack_delay_timer: Timer

#Dash Variables
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.1
@export var dash_delay: float = 0.5
var dash_locked: bool = false

#Player Stats
@export var gravity_modifier: float = 0.2
@export var speed: float = 200.0
@export var jump_velocity: float = -125
var previous_location: Vector2

# coyote time
@export var coyote_time := 0.1
var coyote_timer := 0.0

#Interaction
var can_interact: bool = false

#Climbing
@export var climb_speed: float = 50.0

var knockback_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	attack_pivot.visible = false
	sword_hitbox.monitoring = false 
	
	health_component.died.connect(die)
	previous_location = global_position
	
	health_component.invulnerability_started.connect(_on_invuln_start)
	health_component.invulnerability_ended.connect(_on_invuln_end)
	dash_delay_timer.stop()
	
	attack_delay_timer = Timer.new()
	self.add_child(attack_delay_timer)
	attack_delay_timer.timeout.connect(_on_attack_delay_timer_timeout)
	attack_delay_timer.stop()

func _physics_process(delta: float) -> void:
	match state:
		
		State.HITSTUN:
			_update_hitstun(delta)
			return
			
		State.DASH:
			_update_dash(delta)
			
		State.ATTACK:
			_update_attack(delta)
			
		State.CLIMB:
			_update_climb(delta)
			
		State.NORMAL:
			_update_normal(delta)
	
	previous_location = global_position
	move_and_slide()
	

#NORMAL MOVEMENT
func _update_normal(delta: float) -> void:
	
	_apply_gravity(delta)
	
	#Ground check / coyote
	if is_on_floor():
		coyote_timer = 0.1
	else:
		coyote_time -= delta
	
	#Jump
	if Input.is_action_just_pressed("A_Button") and (is_on_floor() or coyote_timer > 0.0) and not Input.is_action_pressed("D_Pad_Down"):
		if not Input.is_action_pressed("D_Pad_Up"):
			velocity.y = jump_velocity
			coyote_timer = 0.0
		if Input.is_action_pressed("D_Pad_Up") and not dash_locked:
			velocity.y = jump_velocity
			coyote_timer = 0.0
			_start_dash()
			return
	
	#Dash
	if Input.is_action_pressed("D_Pad_Down") and Input.is_action_just_pressed("A_Button") and not dash_locked:
		_start_dash()
		return
	
	#Attack
	if Input.is_action_just_pressed("B_Button") and attack_delay_timer.is_stopped():
		_start_attack()
		return
	
	#CLIMB
	if can_interact and Input.is_action_pressed("D_Pad_Up"):
		_start_climb()
		return
	
	#Movement
	_check_movement()

func _check_movement() -> void:
	var dir := Input.get_axis("D_Pad_Left", "D_Pad_Right")
	
	if dir != 0:
		velocity.x = dir * speed
		player_facing = sign(dir)
		attack_pivot.scale.x = player_facing
		
		sprite.play("walk")
		sprite.flip_h = dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.play("default")


#GRAVITY
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * gravity_modifier * delta
		

#DASH
func _start_dash() -> void:
	state = State.DASH
	dash_locked = true
	
	health_component.is_invulnerable = true
	sprite.play("roll")
	
	dash_timer.start(dash_duration)

func _update_dash(delta: float) -> void:
	if dash_locked and is_on_floor() and dash_timer.is_stopped() and dash_delay_timer.is_stopped():
		_unlock_dash()
		return
	velocity.x = player_facing * dash_speed
	_apply_gravity(delta)

func _on_dash_timer_timeout() -> void:
	dash_timer.stop()
	if is_on_floor():
		_unlock_dash()
	else:
		pass

func _on_dash_delay_timer_timeout() -> void:
	dash_delay_timer.stop()
	dash_locked = false

func _unlock_dash():
	if not dash_locked:
		return
		
	state = State.NORMAL
	health_component.is_invulnerable = false
	sprite.play("default")
	dash_delay_timer.start(dash_delay)


#ATTACK
func _start_attack() -> void:
	state = State.ATTACK
	
	attack_pivot.visible = true
	sword_hitbox.monitoring = true
	
	sprite.play("attack")
	
	await get_tree().create_timer(attack_duration).timeout
	
	attack_pivot.visible = false
	sword_hitbox.monitoring = false
	
	state = State.NORMAL
	
	attack_delay_timer.start(attack_delay)

func _on_attack_delay_timer_timeout() -> void:
	attack_delay_timer.stop()

func _update_attack(delta: float) -> void:
	_apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, speed)


#CLIMB
func _start_climb() -> void:
	state = State.CLIMB
	

func _update_climb(_delta: float) -> void:
	if not can_interact:
		state = State.NORMAL
		return
	
	if Input.is_action_pressed("D_Pad_Up"):
		velocity.y = -climb_speed
	else:
		velocity.y = climb_speed
	
	_check_movement()


#HITSTUN
func apply_attack(attack: Attack, attacker_pos: Vector2):
	state = State.HITSTUN
	var dir = (global_position - attacker_pos).normalized()
	knockback_velocity = Vector2(
		sign(dir.x) * attack.knockback_force,
		attack.knockback_force * -0.5  # upward launch feel
	)
	velocity.y = knockback_velocity.y

func _update_hitstun(delta: float) -> void:
	velocity.x = knockback_velocity.x
	velocity.y += get_gravity().y * gravity_modifier * delta
	
	move_and_slide()
	
	if is_on_floor():
		state = State.NORMAL
		knockback_velocity = Vector2.ZERO

#INVULNERABLE FLASH
var flashing: bool = false

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


#MISC
func die() -> void:
	pass
func _on_interactbox_component_body_entered(_body: Node2D) -> void:
	can_interact = true

func _on_interactbox_component_body_exited(_body: Node2D) -> void:
	can_interact = false
