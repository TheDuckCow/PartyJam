extends Node3D

signal change_gamestate(game_state:int)

enum GameState {
	INSTRUCTIONS,
	INTRO_ANIM,
	PLAYING,
	ENDED
}

const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")


@export var generator: Node3D
@export var reporter_audio: AudioStreamPlayer
@export var anim_player: AnimationPlayer

## Reference of all players in the scene
var players: Array[FreezePlayer] = []

## When player interactivity actually begun
var start_ticks: int


func _ready() -> void:
	populate_players()
	
	# TODO: setup intro etc
	reporter_audio.finished.connect(start_game)


func _unhandled_input(event: InputEvent) -> void:
	# check input type
	intro_anim()
	pass


func populate_players() -> void:
	for ch in get_children():
		if ch is FreezePlayer:
			print("Append players", ch)
			players.append(ch)
			ch.state = FreezePlayer.State.CUTSCENE
			var res = change_gamestate.connect(ch._on_gamestate_updated)
			assert(res == OK)
	if not players:
		push_error("Could not identify any freeze slide players")
	generator.players = players


func intro_anim(passvar = null) -> void:
	anim_player.play("report_to_gameview")
	start_game() # connect to end of signal


## Run after the intro splash updates
func start_game() -> void:
	start_ticks = Time.get_ticks_msec()
	change_gamestate.emit(GameState.PLAYING)
	

func end_game(winning_player:FreezePlayer) -> void:
	match winning_player.player:
		FreezePlayer.Player.A:
			Global.playerWins(1)
		FreezePlayer.Player.B:
			Global.playerWins(2)
