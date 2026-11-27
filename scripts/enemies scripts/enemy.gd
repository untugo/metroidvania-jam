extends Area2D

@onready var colider = $CollisionShape2D

var health: int = 3
var damage: float
var velocity: Vector2

func _physics_process(_delta: float) -> void:
	if health <= 0.0:
		self.queue_free()
