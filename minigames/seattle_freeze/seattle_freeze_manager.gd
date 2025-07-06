extends Node3D

signal change_gamestate(game_state:int)

enum GameState {
	INSTRUCTIONS,
	INTRO_ANIM,
	PLAYING,
	ENDED
}

const max_time_msec := 10000 # Update to 20 * 1000
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
var msec_remaining: int = 0


func _ready() -> void:
	populate_players()
	
	# TODO: setup intro etc
	reporter_audio.finished.connect(intro_anim)
	change_gamestate.connect(cam.set_new_offset)
	set_state(GameState.INSTRUCTIONS)


func _process(delta: float) -> void:
	_update_mmsec_remaining()


func set_state(new_state: int) -> void:
	state = new_state
	change_gamestate.emit(state)
	
	match state:
		GameState.INSTRUCTIONS:
			reporter_audio.play(0.0)
		GameState.INTRO_ANIM:
			reporter_audio.stop()


func _unhandled_input(event: InputEvent) -> void:
	if not state in [GameState.INSTRUCTIONS, GameState.ENDED]:
		return
	var do_continue: bool = event.is_action("esc") \
							or event.is_action("p1_action1") \
							or event.is_action("p1_action2") \
							or event.is_action("p1_action2") \
							or event.is_action("p2_action2")
	if do_continue:
		if state == GameState.INSTRUCTIONS:
			intro_anim()
		else:
			# Return to menu
			Global.loadNewScene()


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


func _update_mmsec_remaining() -> void:
	if state in [GameState.INSTRUCTIONS, GameState.INTRO_ANIM]:
		return
	var ticks = Time.get_ticks_msec()
	var duration = ticks - start_ticks
	msec_remaining = clamp(max_time_msec - duration, 0, max_time_msec)
	if msec_remaining == 0 and state == GameState.PLAYING:
		var winner := get_leading_player()
		end_game(winner)


func get_leading_player() -> FreezePlayer:
	var leading_player: FreezePlayer
	var leading_z:float
	for _player in players:
		var _z:float = _player.global_position.z
		if not is_instance_valid(leading_player) or leading_z < _z:
			leading_player = _player
			leading_z = _z
			leading_z = _player.global_position.z
	return leading_player


func check_remaining_time_msec() -> int:
	return msec_remaining
