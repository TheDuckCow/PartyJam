extends Control

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

@export var time_remaining: Label

@onready var manager:FreezeManager = get_parent()
@onready var win_screens := %BreakingNews
@onready var player_winner := %won_player_label
@onready var anim_player := $AnimationPlayer


func _ready() -> void:
	manager.change_gamestate.connect(_on_state_change)
	win_screens.visible = false
	anim_player.play("intro")


func _process(_delta: float) -> void:
	var time_left := manager.check_remaining_time_msec() / 1000.0
	var new_text := "Coverage ending in %0.1f s" % time_left
	time_remaining.text = new_text


func _on_state_change(new_state) -> void:
	if new_state == FreezeManager.GameState.PLAYING:
		anim_player.play("being_minigame")
	elif new_state == FreezeManager.GameState.ENDED:
		_on_winner(manager.winner)


func _on_winner(player_number: int) -> void:
	player_winner.text = "PLAYER %s WINS" % player_number
	win_screens.visible = true
	anim_player.play("endgame")


func _on_continue_pressed() -> void:
	print("Back to menu...")
	pass # Replace with function body.
