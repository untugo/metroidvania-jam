class_name MovementComponent
extends Node

@export var body: CharacterBody2D

var direction: float
var velocity: Vector2
var jump_velocity: float = -400.0

var peak_velocity_ground: float = 350.0
var peak_velocity_air: float = 300.0

var current_friction: float
var friction_ground: float = 1200.0
var friction_air: float = 100.0

var current_accel_rate: float
var accel_rate_ground: float = 1700.0
var accel_rate_air: float = 900.0

#var jump_time_timer: float
#var jump_time_timer_time: float = 2
var jump_cut_factor: float = 0.35


func _physics_process(delta: float) -> void:
	if !body: return
	
	calculate_movement()
	apply_movement(delta)

	body.velocity = velocity
	body.move_and_slide()
	velocity = body.velocity


func calculate_movement() -> void:
	if !body.ring_state:
		direction = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	else: direction = 0.0


#add input buffer + coyote time
func apply_movement(delta: float) -> void:
	var target_speed: float
	var current_direction: float = sign(velocity.x)

	if body.is_on_floor():
		target_speed = peak_velocity_ground
		current_accel_rate = accel_rate_ground
		current_friction = friction_ground
		
		if Input.is_action_just_pressed("ui_accept"): 
			velocity.y = jump_velocity

	else:
		target_speed = peak_velocity_air
		current_accel_rate = accel_rate_air
		current_friction = friction_air
		
		if body.ring_state:
			velocity = lerp(velocity, Vector2.ZERO, 6 * delta)
		else: velocity += body.get_gravity() * delta
		
		if Input.is_action_just_released("ui_accept") and velocity.y < -100.0: 
			velocity.y *= jump_cut_factor

	if direction != 0.0:
		var alignment := Vector2(current_direction, 0.0).dot(Vector2(direction, 0.0))
		
		if alignment < 0.0:
			velocity.x = move_toward(velocity.x, 0.0, 9850 * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * target_speed, current_accel_rate * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_friction * delta)
