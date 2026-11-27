extends Node2D

@onready var player = self.get_parent()
@onready var velocity: Vector2 = player.velocity

var damage: int = 0
var health: int = 3
var dead: float = false

# this is a dictionary of tiers. the first number shows the damage, the second one shows the invenurability.
var tiers: Dictionary = {"one": [0, false], "two": [0, false], "three": [1, false], "four": [2, true], "five": [3, true]}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_velocity()
	
	if not dead:		
		if health <= 0:
			print("i mean you're kinda dead but i'll make you invisible for now")
			player.visible = false
			dead = true


func update_velocity():
	velocity = player.velocity


func _on_colision_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		print("aw i got damaged")
		health -= 1
