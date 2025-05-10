extends Label

func _ready() -> void:
	var score = "Player 2: " + str(Global.playerTwoWins)
	text = score
