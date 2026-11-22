class_name CameraComponent
extends Node

@export var camera: Camera2D
@export var body: CharacterBody2D

#@export var alt_camera: Camera2D
#@export var marker: Marker2D

var min_zoom: Vector2 = Vector2(1.3, 1.3)
var max_zoom: Vector2 = Vector2(0.92, 0.92)
var base_zoom: Vector2 = Vector2(1.0, 1.0)
var target_zoom: Vector2


#I usualy have a separate node with all my timers...
var reset_zoom_timer: float
var reset_zoom_time: float = 2.5

var update_zoom_timer: float
var update_zoom_time: float = 1.0

var idle_timer: float
var idle_timer_time: float = 7.0
var default_position: Vector2


func _ready() -> void:
	camera.zoom = base_zoom
	target_zoom = base_zoom
	idle_timer = idle_timer_time
	reset_zoom_timer = reset_zoom_time
	update_zoom_timer = update_zoom_time


#might rewrite this as a state machine
func _process(delta: float) -> void:
	if !body: return
	var velocity: float = absf(body.velocity.x)
	#camera.global_position.x = lerp(camera.global_position.x, body.global_position.x, delta * 100)

	if velocity >= 200.0:
		reset_zoom_timer = reset_zoom_time
		update_zoom_timer -= 1 * delta
		if update_zoom_timer <= 0.0: target_zoom = max_zoom
	else:
		update_zoom_timer = update_zoom_time
		reset_zoom_timer -= 1 * delta
		if reset_zoom_timer <= 0.0: target_zoom = base_zoom

#a state machine would work better
	#if velocity <= 0.0:
		#idle_timer -= 1 * delta
		#if idle_timer <= 0.0: target_zoom = min_zoom
	#else: 
		#idle_timer = idle_timer_time
		#target_zoom = base_zoom

	camera.zoom = camera.zoom.lerp(target_zoom, delta * 0.8)

#func update_ring_camera(delta):
	##if !alt_camera: return
	##if alt_camera.is_current():
	#
	#var target_position: Vector2 = marker.global_position
	#camera.drag_horizontal_enabled = false
	#camera.global_position = lerp(camera.global_position, target_position, 150 * delta)
	#else: return
