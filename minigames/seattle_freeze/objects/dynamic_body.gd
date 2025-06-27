extends CharacterBody3D

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

var GRAVITY:float = ProjectSettings.get_setting("physics/3d/default_gravity")


var dislodged := false


var input_faster: String
var input_slower: String


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	if dislodged:
		velocity.z -= delta * 5
		velocity.z = clamp(velocity.z, -1000.0, 0.0)
	
	var _res = move_and_slide()
