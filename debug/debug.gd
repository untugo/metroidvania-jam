extends Label

@onready var controls: Label = $controls
@onready var debug: Label = $"."
@export var body: CharacterBody2D
@export var hand: Hand


func _process(delta: float) -> void:
	debug.text = (
	str("velocity X: " + "%d" % body.velocity.x) + "\n" +
	str("velocity Y: " + "%d" % body.velocity.y) + "\n" +
	"proximity objects: " + str(hand.proximity_objects.size()) + "\n" +
	"held object: " + str(hand.held_object)


)


	if hand.held_object: controls.visible = true
	else: controls.visible = false
