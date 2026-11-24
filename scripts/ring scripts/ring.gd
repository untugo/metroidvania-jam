class_name Ring
extends Pickable

enum STATES { HELD, THROWN, LOCKED, RETURNING, DROPPED }
var state: STATES = STATES.DROPPED

var owner_player: Node2D = null
var current_anchor: RingAnchor = null


func _ready() -> void:
	freeze = true


func throw(direction: Vector2, power: float):
	if state == STATES.HELD or state == STATES.DROPPED:
		state = STATES.THROWN
		freeze = false
		
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0

		apply_central_impulse(direction.normalized() * power)
		apply_torque_impulse(randf_range(-200, 200))


func request_lock(anchor: RingAnchor, delta: float):
	if not anchor: return
	
	current_anchor = anchor
	state = STATES.LOCKED
	freeze = true
	global_position = global_position.lerp(anchor.global_position, 25.0 * delta)


func unlock():
	if state == STATES.LOCKED:
		state = STATES.DROPPED
		current_anchor = null
		freeze = false


#not sure how this could work yet
func recall():
	pass


func can_dash_to() -> bool:
	return state == STATES.LOCKED or state == STATES.THROWN


func get_dash_target() -> Vector2:
	if current_anchor:
		return current_anchor.global_position
	return global_position
