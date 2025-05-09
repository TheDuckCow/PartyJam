extends Node

var playerOneWins = 0
var playerTwoWins = 0

var lastGameIndex = null

func playerWins(whichPlayerWon: int):
	if whichPlayerWon == 1:
		playerOneWins+=1
	elif whichPlayerWon == 2:
		playerTwoWins+=1
	else:
		printerr("Winning Player not recognized!")

func loadNewScene(scenePath: String = "res://menu.tscn"):
	if scenePath.get_extension() == "tscn":
		get_tree().change_scene_to_file(scenePath)
	else:
		var success = ProjectSettings.load_resource_pack(scenePath)
		if success:
			var unpackedScene = scenePath.trim_suffix(".pck") + ".tscn"
			print("unpackedScene: ", unpackedScene)
			get_tree().change_scene_to_file(unpackedScene)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://menu.tscn")
		get_viewport().set_input_as_handled()
