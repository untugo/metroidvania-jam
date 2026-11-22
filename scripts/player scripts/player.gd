extends CharacterBody2D

signal ring(pos: Vector2, direction: Vector2)
signal dash()

const LAUNCH_POWER = 800.0
const DASH_DURATION = 0.20

@export var ring_state: bool = false
@onready var aim_pivot: Node2D = $AimPivot
@onready var ring_node: RigidBody2D = get_node_or_null("../Ring")
@onready var radius_area: Area2D = ring_node.get_node_or_null("RadiusArea") if ring_node else null

#could make a cleaner camera system
@onready var ring_camera: Camera2D = $Cameras/RingCamera
@onready var movement_camera: Camera2D = $Cameras/MovementCamera
@onready var camera_component: CameraComponent = $"Camera Component"

var _dash_timer: float = 0.0
var ring_hold_timer: float = 1.0
var ring_hold_time: float = 1.0
var target_launch_velocity: Vector2

func _physics_process(delta: float) -> void:
	aim_pivot.look_at(get_global_mouse_position())
	
	if _dash_timer > 0.0:
		_dash_timer -= delta


func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ring") and not event.is_echo():
		#_toggle_ring_state()

	if event.is_action_pressed("ring") and not event.is_echo():
		#if !ring_state:
		start_aiming()

	if event.is_action_released("ring"):
		#if ring_state: 
		release_ring()

	if event.is_action_pressed("dash") and not event.is_echo() and ring_node:
		var to_ring := ring_node.global_position - global_position
		if to_ring.length() > 1.0 and is_in_ring_radius() and ring_node.visible:
			target_launch_velocity = to_ring.normalized() * LAUNCH_POWER
			_dash_timer = DASH_DURATION
			emit_signal("dash")


func start_aiming():
	#if ring_state: 
	ring_state = true
	aim_pivot.visible = true
	Engine.time_scale = 0.2
	#ring_camera.make_current()


func release_ring():
	ring_state = false
	aim_pivot.visible = false
	#movement_camera.make_current()
	
	var aim_dir := Vector2.RIGHT.rotated(aim_pivot.global_rotation)
	if ring_node:
		ring_node.teleport_and_launch(global_position, aim_dir)
		ring.emit(global_position, aim_dir)
		Engine.time_scale = 1.0


#func _toggle_ring_state() -> void:
	#ring_state = not ring_state
	#aim_pivot.visible = ring_state
#
	#if ring_state:
		#Engine.time_scale = 0.25
	#else:
		#var aim_dir := Vector2.RIGHT.rotated(aim_pivot.global_rotation)
		#if ring_node:
			#ring_node.teleport_and_launch(global_position, aim_dir)
		#ring.emit(global_position, aim_dir)
		#Engine.time_scale = 1.0


func is_in_ring_radius() -> bool:
	if not radius_area:
		return false
	return radius_area.overlaps_body(self)
