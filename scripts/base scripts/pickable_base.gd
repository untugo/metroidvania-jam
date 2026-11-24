#some state logic from ring.gd could be moved here 

class_name Pickable
extends RigidBody2D

enum STATES { HELD, THROWN, LOCKED, RETURNING, DROPPED }
var state: STATES = STATES.DROPPED
var object = self

func _process(delta: float) -> void:
	print(state)


func _ready() -> void:
	gravity_scale = 2.0
	linear_damp = 2.0


#right now the holder is set from the player's "hand" when calling pick_up()
#we can use process in the sub classes to move the objects
func pick_up(holder):
	state = STATES.HELD
	object.freeze = true
	object.angular_velocity = 0.0
	object.linear_velocity = Vector2.ZERO


func throw(direction: Vector2, power: float):
	if state == STATES.HELD or state == STATES.DROPPED:
		object.current_holder = null #there has to be a better way to do this
		state = STATES.THROWN
		freeze = false
		
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0

		apply_central_impulse(direction.normalized() * power)
		apply_torque_impulse(randf_range(-200, 200))


func drop():
	pass
