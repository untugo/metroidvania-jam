#some state logic from ring.gd could be moved here 

class_name Pickable
extends RigidBody2D

var object = self


func _ready() -> void:
	pass # Replace with function body.


func pick_up():
	#object.state = state..?
	object.freeze = true
	object.angular_velocity = 0.0
	object.linear_velocity = Vector2.ZERO
