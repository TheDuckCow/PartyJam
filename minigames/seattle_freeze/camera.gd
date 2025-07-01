extends Camera3D

const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")
const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

## Offset to use from the actual midpoint, since there might be some tilt
var offset: Vector3 = Vector3.ZERO
var playing: bool = false

func _ready() -> void:
	pass


func set_new_offset(new_state: int) -> void:
	if new_state == FreezeManager.GameState.PLAYING:
		print("Offset assigned during playing state")
		var players: Array[FreezePlayer] = get_parent().players
		var player_midpoint = get_player_midpoint(players)
		
		# Then, identify the offset to give such that this xz player midpoint
		# resutls in this current transform.
		offset = global_position - player_midpoint
		print("Offset: ", offset)
		playing = true
	elif new_state == FreezeManager.GameState.ENDED:
		playing = true


func _process(_delta: float) -> void:
	if playing == false:
		return
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
