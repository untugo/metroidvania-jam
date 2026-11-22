extends RigidBody2D

@export var impulse: float = 1.042

var _pending_pos: Vector2 = Vector2.ZERO
var _has_pending_pos: bool = false
var _pending_impulse: Vector2 = Vector2.ZERO


func _ready() -> void:
	gravity_scale = 0.0
	linear_damp = 2.0


func _physics_process(_delta: float) -> void:
	pass


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _has_pending_pos:
		state.transform.origin = _pending_pos
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		_has_pending_pos = false
		
		self.visible = true
		
	if _pending_impulse != Vector2.ZERO:
		state.apply_central_impulse(_pending_impulse)
		_pending_impulse = Vector2.ZERO


func teleport_and_launch(target_pos: Vector2, direction: Vector2) -> void:
	freeze = false
	sleeping = false
	_pending_pos = target_pos
	_has_pending_pos = true
	_pending_impulse = direction.normalized() * impulse


func _on_player_ring(pos: Vector2, direction: Vector2) -> void:
	teleport_and_launch(pos, direction)


func _on_player_dash() -> void:
	self.visible = false
