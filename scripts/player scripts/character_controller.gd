class_name MovementComponent
extends Node

@export var body: CharacterBody2D

var direction: float
var velocity: Vector2

@export var jump_velocity: float = -400.0
@export var peak_velocity_air: float = 300.0
@export var peak_velocity_ground: float = 350.0

var current_friction: float
@export var friction_air: float = 100.0
@export var friction_ground: float = 1200.0
@export var turn_around_friction: float = 9850.0

var current_accel_rate: float
@export var accel_rate_air: float = 900.0
@export var accel_rate_ground: float = 1700.0

#var jump_time_timer: float
#var jump_time_timer_time: float = 2
@export var jump_cut_factor: float = 0.35

#controll flags
var can_move: bool = true           #false to lock movement
var force_stop: bool = false        #true to kill velocity
var apply_gravity: bool = true      #false to stop apply gravity gravity


func _physics_process(delta: float):
	if !body: return
	
	calculate_movement()
	apply_movement(delta)

	body.velocity = velocity
	body.move_and_slide()
	velocity = body.velocity


func calculate_movement():
	if can_move:
		direction = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	else: direction = 0.0


#add input buffer + coyote time later
func apply_movement(delta: float):
	var on_floor: bool = body.is_on_floor()
	var target_speed: float = peak_velocity_ground if on_floor else peak_velocity_air
	
	
	current_accel_rate = accel_rate_ground if on_floor else accel_rate_air
	current_friction = friction_ground if on_floor else friction_air


	if !on_floor and apply_gravity:
		velocity += body.get_gravity() * delta
	
	if on_floor and Input.is_action_just_pressed("ui_accept"): 
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("ui_accept") and velocity.y < -100.0: 
		velocity.y *= jump_cut_factor
	
	if force_stop:
		body.velocity = lerp(body.velocity, Vector2.ZERO, 12 * delta)
	
	
	if direction != 0.0:
		var alignment: float = Vector2(velocity.x, 0.0).dot(Vector2(direction, 0.0))
		
		if alignment < 0.0:
			velocity.x = move_toward(velocity.x, 0.0, 9850 * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * target_speed, current_accel_rate * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_friction * delta)


#used by player states
func set_control_mode(moving: bool, gravity: bool = true, stop: bool = false):
	can_move = moving
	apply_gravity = gravity
	force_stop = stop


func add_impulse(impulse: Vector2):
	velocity += impulse


func set_velocity(new_vel: Vector2):
	velocity = new_vel
