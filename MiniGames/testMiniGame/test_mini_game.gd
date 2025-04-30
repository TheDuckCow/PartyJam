extends Node2D
var titleScreenOn = false
var victoryScreenOn = false

func _ready() -> void:
	toggleTitleScreen()
	
func toggleTitleScreen():
	titleScreenOn = !titleScreenOn
	$TitleScreen.visible = !$TitleScreen.visible
	
func playersTitleInput():
	if Input.is_action_just_pressed("p1_action1") or Input.is_action_just_pressed("p1_action2"):
		toggleTitleScreen()
		print("Player 1 dismiss titlescreen")
		return
	elif Input.is_action_just_pressed("p2_action1") or Input.is_action_just_pressed("p2_action2"):
		toggleTitleScreen()
		print("Player 2 dismiss titlescreen")
		return
	else:
		return
			
func playersGameInput():
	$Player.playerInput()
	$Player2.playerInput()

func _process(delta: float) -> void:
	if titleScreenOn == true:
		playersTitleInput()
	elif victoryScreenOn == true:
		victoryScene()
	elif titleScreenOn == false:
		playersGameInput()

func _on_end_zone_body_entered(body: Node2D) -> void:
	if body == $Player:
		Global.playerWins(1)
	elif body == $Player2:
		Global.playerWins(2)
	
	var winnerText = "The Winner is: \n" + body.name + "\n\n Press your action buttons to continue to menu."
	$VictoryScreen.SetWinner(winnerText)
	$VictoryScreen.visible = true
	victoryScreenOn = true
	
func victoryScene():
	if Input.is_action_just_pressed("p1_action1") or Input.is_action_just_pressed("p1_action2") or Input.is_action_just_pressed("p2_action1") or Input.is_action_just_pressed("p2_action2"):
		Global.loadNewScene()
