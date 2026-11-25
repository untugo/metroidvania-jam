class_name Ring
extends Pickable

#var owner_player: Node2D = null
var current_anchor: Marker2D = null


func _ready() -> void:
	gravity_scale = 2.0
	linear_damp = 2.0
	freeze = false


func _process(delta: float) -> void:
	update_position(current_holder)


func pick_up(holder):
	state = STATES.HELD
	object.freeze = true
	#object.visible = disabled for debuging
	object.angular_velocity = 0.0
	object.linear_velocity = Vector2.ZERO
	current_holder = holder


func update_position(current_holder):
	if !current_holder: return
	object.global_position = current_holder.global_position
	object.rotation = current_holder.global_rotation


func request_lock(anchor: Marker2D, delta: float):
	if state == STATES.DROPPED or state == STATES.HELD: return
	
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
