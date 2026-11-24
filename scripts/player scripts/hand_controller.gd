class_name Hand
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


func _on_reach_body_entered(body: Pickable) -> void:
	proximity_objects.append(body)

func _on_reach_body_exited(body: Node2D) -> void:
	proximity_objects.erase(body)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ACTION_01") and not event.is_echo():
		if held_object: held_object.drop()
		else: try_pick()

	if event.is_action_pressed("ACTION_02") and not event.is_echo():
		if held_object: start_aiming()
		else: confusion()

	if event.is_action_released("ACTION_02") and is_aiming:
		throw_held_object()


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
	if !proximity_objects: return
	if ring and ring.state == Ring.STATES.DROPPED or ring.state == Ring.STATES.THROWN:
		pick_up(ring)


func pick_up(object: Pickable):
	if not object or object.state == object.STATES.HELD: return
	held_object = object
	object.pick_up(hand_socket)


func throw_held_object():
	stop_aiming()
	
	#var throw_direction: Vector2 = (get_global_mouse_position() - hand_socket.global_position).normalized()
	var throw_direction: Vector2 = Vector2.RIGHT.rotated(aim_pivot.global_rotation).normalized()
	var throw_power: float = 3.042

#ring based, the logic could be moved to pickable_base.gd to make ir common
	if held_object is Ring:
		var ring = held_object as Ring
		ring.throw(throw_direction, throw_power)
	
	held_object = null
