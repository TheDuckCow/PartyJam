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
	get_tree().change_scene_to_file(scenePath)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://menu.tscn")
		get_viewport().set_input_as_handled()
