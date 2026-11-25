class_name RingAnchor
extends Node


@export var anchor_locked: bool = false
@onready var left: Sprite2D = $"outer layer/left"
@onready var right: Sprite2D = $"outer layer/right"
@onready var anchor_point: Marker2D = $"anchor point"

@onready var debug_hint: Label = $"debug hint"

var can_lock: bool = false
var locked_ring: Ring = null
var locked_rings: int = 0


func _ready() -> void:
	debug_hint.visible = false


func _process(delta: float) -> void:
	if locked_rings > 1: return
	if !can_lock or anchor_locked: return
	locked_ring.request_lock(anchor_point, delta)


func _on_anchor_area_body_entered(body: Ring) -> void:
	can_lock = true
	locked_rings += 1
	locked_ring = body
	debug_hint.visible = true

	left.position += Vector2(8, 0)
	right.position -= Vector2(8, 0)

func _on_anchor_area_body_exited(body: Node2D) -> void:
	can_lock = false
	locked_rings -= 1
	locked_ring = null
	debug_hint.visible = false

	left.position -= Vector2(8, 0)
	right.position += Vector2(8, 0)
