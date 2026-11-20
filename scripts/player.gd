extends CharacterBody2D

signal ring(pos: Vector2, direction: Vector2)
signal dash()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const LAUNCH_POWER = 800.0
const DASH_DURATION = 0.20

@export var ring_state: bool = false
@onready var aim_pivot: Node2D = $AimPivot
@onready var ring_node: RigidBody2D = get_node_or_null("../Ring")
@onready var radius_area: Area2D = ring_node.get_node_or_null("RadiusArea") if ring_node else null

var _dash_timer: float = 0.0

func _physics_process(delta: float) -> void:
	aim_pivot.look_at(get_global_mouse_position())

	if _dash_timer > 0.0:
		_dash_timer -= delta
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ring") and not event.is_echo():
		_toggle_ring_state()

	if event.is_action_pressed("dash") and not event.is_echo() and ring_node:
		var to_ring := ring_node.global_position - global_position
		if to_ring.length() > 1.0 and is_in_ring_radius() and ring_node.visible:
			velocity = to_ring.normalized() * LAUNCH_POWER
			_dash_timer = DASH_DURATION
			emit_signal("dash")


func _toggle_ring_state() -> void:
	ring_state = not ring_state
	aim_pivot.visible = ring_state

	if ring_state:
		Engine.time_scale = 0.25
	else:
		var aim_dir := Vector2.RIGHT.rotated(aim_pivot.global_rotation)
		if ring_node:
			ring_node.teleport_and_launch(global_position, aim_dir)
		ring.emit(global_position, aim_dir)
		Engine.time_scale = 1.0


func is_in_ring_radius() -> bool:
	if not radius_area:
		return false
	return radius_area.overlaps_body(self)
