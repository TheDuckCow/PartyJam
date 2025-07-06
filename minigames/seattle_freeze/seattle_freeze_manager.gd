extends Node3D

signal change_gamestate(game_state:int)

enum GameState {
	INSTRUCTIONS,
	INTRO_ANIM,
	PLAYING,
	ENDED
}

const max_time_msec := 20000
const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")

@export var generator: Node3D
@export var reporter_audio: AudioStreamPlayer
@export var anim_player: AnimationPlayer
@export var cam: Camera3D
@export var far_plane: Node3D
@export var close_plane: Node3D

## Reference of all players in the scene
var players: Array[FreezePlayer] = []
## When player interactivity actually begun
var start_ticks: int
## Game state value, matched to GameState
var state: int = 0
var winner: int = -1


func _ready() -> void:
	populate_players()
	
	# TODO: setup intro etc
	reporter_audio.finished.connect(intro_anim)
	change_gamestate.connect(cam.set_new_offset)
	set_state(GameState.INSTRUCTIONS)


func set_state(new_state: int) -> void:
	state = new_state
	change_gamestate.emit(state)
	
	match state:
		GameState.INSTRUCTIONS:
			reporter_audio.play(0.0)
		GameState.INTRO_ANIM:
			reporter_audio.stop()


func _unhandled_input(event: InputEvent) -> void:
	if state != GameState.INSTRUCTIONS:
		return
	var do_continue: bool = event.is_action("esc") \
							or event.is_action("p1_action1") \
							or event.is_action("p1_action2") \
							or event.is_action("p1_action2") \
							or event.is_action("p2_action2")
	if do_continue:
		intro_anim()


func populate_players() -> void:
	for ch in get_children():
		if ch is FreezePlayer:
			print("Append players", ch)
			players.append(ch)
			ch.state = FreezePlayer.State.CUTSCENE
			change_gamestate.connect(ch._on_gamestate_updated)
			ch.far_plane = far_plane
			ch.close_plane = close_plane
	if not players:
		push_error("Could not identify any freeze slide players")
	generator.players = players


func intro_anim(_discard = null) -> void:
	anim_player.play("report_to_gameview")
	set_state(GameState.INTRO_ANIM)
	anim_player.animation_finished.connect(start_game)


## Run after the intro splash updates
func start_game(_discard = null) -> void:
	print("Game start")
	anim_player.animation_finished.disconnect(start_game)
	start_ticks = Time.get_ticks_msec()
	set_state(GameState.PLAYING)


func end_game(winning_player:FreezePlayer) -> void:
	if state == GameState.ENDED:
		push_warning("Already ended")
		return
	print("Minigame ended with winner: ", winning_player.player)
	match winning_player.player:
		FreezePlayer.Player.A:
			winner = 1
		FreezePlayer.Player.B:
			winner = 2
	Global.playerWins(winner)
	set_state(GameState.ENDED)


func check_remaining_time_msec() -> int:
	var ticks = Time.get_ticks_msec()
	var duration = ticks - start_ticks
	return max_time_msec - duration
