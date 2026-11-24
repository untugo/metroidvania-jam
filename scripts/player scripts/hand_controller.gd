extends Node2D

@export var aim_pivot: Node2D
@export var movement_component: MovementComponent

@onready var ring: Ring = get_node_or_null("../../Ring") as Ring
@onready var hand_socket: Marker2D = $"hand socket"

var proximity_objects: Array = []
var held_object: Pickable = null
var is_aiming: bool = false


func _process(delta: float) -> void:
	if is_aiming and aim_pivot:
		aim_pivot.look_at(get_global_mouse_position())

	if held_object and held_object is Ring:
		held_object.global_position = hand_socket.global_position
		held_object.rotation = hand_socket.global_rotation


func _on_reach_body_entered(body: Pickable) -> void:
	proximity_objects.append(body)

func _on_reach_body_exited(body: Node2D) -> void:
	proximity_objects.erase(body)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ACTION_01") and not event.is_echo():
		if held_object: throw_held_object()
		else: try_pick()




func start_aiming():
	is_aiming = true
	if aim_pivot: aim_pivot.visible = true
	Engine.time_scale = 0.2


func stop_aiming():
	is_aiming = false
	if aim_pivot: aim_pivot.visible = false
	Engine.time_scale = 1.0


#ring based for the sake of the jam
#could use add proximity logic here
func try_pick():
	if ring and ring.state == Ring.STATES.DROPPED or ring.state == Ring.STATES.THROWN:
		pick_up(ring)


func pick_up(object: Pickable):
	if not object: return
	held_object = object
	object.pick_up()


func throw_held_object():
	if not held_object: return
	stop_aiming()
	
	var throw_dir = (get_global_mouse_position() - hand_socket.global_position).normalized()
	var throw_power = 800.0

#ring based, the logic could be moved to pickable_base.gd to make ir common
	if held_object is Ring:
		var ring = held_object as Ring
		ring.throw(throw_dir, throw_power)
	
	held_object = null
