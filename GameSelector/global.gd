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
