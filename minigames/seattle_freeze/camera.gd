extends Camera3D

const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")

## Offset to use from the actual midpoint, since there might be some tilt
var offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	offset.x = global_position.x
	offset.y = global_position.y
	offset.z = global_position.z


func _process(delta: float) -> void:
	set_camera_zy()


func set_camera_zy() -> void:
	var players: Array[FreezePlayer] = get_parent().players
	var player_midpoint = get_player_midpoint(players)
	global_position = player_midpoint + offset


func get_player_midpoint(spatials: Array[FreezePlayer]) -> Vector3:
	if spatials.size() == 0:
		return Vector3.ZERO
	
	var midpoint := Vector3.ZERO
	for _node in spatials:
		midpoint += _node.global_position
	midpoint /= spatials.size()
	return midpoint
