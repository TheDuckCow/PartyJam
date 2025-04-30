extends Label

func _ready() -> void:
	var score = "Player 1: " + str(Global.playerOneWins)
	text = score
