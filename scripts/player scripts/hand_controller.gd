class_name Hand
extends Node2D

@export var aim_pivot: Node2D
@export var movement_component: MovementComponent
@onready var hand_socket: Marker2D = $"hand socket"


var is_aiming: bool = false
var proximity_objects: Array = []

var held_object: Pickable = null
var previous_held_object: Pickable = null


func _process(delta: float) -> void:
	if is_aiming and aim_pivot:
		aim_pivot.look_at(get_global_mouse_position())


func _on_reach_body_entered(body: Pickable) -> void:
	proximity_objects.append(body)

func _on_reach_body_exited(body: Node2D) -> void:
	proximity_objects.erase(body)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ACTION_01") and not event.is_echo():
		if held_object: held_object.drop() #doesn't work at the moment
		else: try_pick()

	if event.is_action_pressed("ACTION_02") and not event.is_echo():
		if held_object: start_aiming()
		else: confusion()

	if event.is_action_released("ACTION_02") and is_aiming:
		throw_held_object()

	if event.is_action_pressed("ACTION_03") and not event.is_echo():
		if !previous_held_object: return
		if previous_held_object.has_method("unlock"): previous_held_object.unlock()
		else: confusion()


func start_aiming():
	is_aiming = true
	if aim_pivot: aim_pivot.visible = true
	Engine.time_scale = 0.2


func stop_aiming():
	is_aiming = false
	if aim_pivot: aim_pivot.visible = false
	Engine.time_scale = 1.0


#placeholder
func confusion():
	print("nothing happened")


#ring based for the sake of the jam
#make more generic logic..?
func try_pick():
	for object in proximity_objects:
		if object.state == object.STATES.DROPPED or object.state == object.STATES.THROWN:
			pick_up(object)
			return


func pick_up(object: Pickable):
	if !object or object.state == object.STATES.HELD: return
	held_object = object
	object.pick_up(hand_socket)


func throw_held_object():
	stop_aiming()
	#var throw_direction: Vector2 = (get_global_mouse_position() - hand_socket.global_position).normalized()
	var throw_direction: Vector2 = Vector2.RIGHT.rotated(aim_pivot.global_rotation).normalized()
	var throw_power: float = 3.042
	held_object.throw(throw_direction, throw_power)

	previous_held_object = held_object
	held_object = null
