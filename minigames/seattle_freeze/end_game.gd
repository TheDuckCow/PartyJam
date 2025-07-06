extends Area3D

const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")
const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

func _on_body_entered(body: Node3D) -> void:
	if not body is FreezePlayer:
		#push_error("Should only be visible to freeze players")
		return
	#var generator = get_parent().get_parent()
	var manager:FreezeManager = get_node("../../../")
	manager.end_game(body)
