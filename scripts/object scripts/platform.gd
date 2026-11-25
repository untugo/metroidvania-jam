extends Pickable



#0.003 platform is not floor
#0.005 platform is floor

#we could make the platform break to avoid players abusing it
#it respwans shortly after tho


func _ready() -> void:
	apply_torque_on_throw = false


func pick_up(holder):
	state = STATES.HELD
	object.angular_velocity = 0.0
	object.linear_velocity = Vector2.ZERO
	current_holder = holder
