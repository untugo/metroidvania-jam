extends Label

@onready var debug: Label = $"."
@export var body: CharacterBody2D


func _process(delta: float) -> void:
	debug.text = str("velocity X: " + "%d" % body.velocity.x) + "\n" + str("velocity Y: " + "%d" % body.velocity.y)
