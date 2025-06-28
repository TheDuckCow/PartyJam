extends CharacterBody3D

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

var GRAVITY:float = ProjectSettings.get_setting("physics/3d/default_gravity")


enum State {CUTSCENE, PLAYING, ENDED}
enum Player {A, B}
@export var state: State = State.CUTSCENE
@export var player: Player = Player.A

@onready var colormesh := %colorized


var input_faster: String
var input_slower: String

func _ready() -> void:
	var mesh_col:Color
	match player:
		Player.A:
			input_faster = "p1_action2"
			input_slower = "p1_action1"
			mesh_col = Color("c4003a")
		Player.B:
			input_faster = "p2_action2"
			input_slower = "p1_action1"
			mesh_col = Color("126cb1")
	var mat:StandardMaterial3D = colormesh.get_surface_override_material(0)
	var new_mat := mat.duplicate(true)
	mat.albedo_color = mesh_col
	colormesh.set_surface_override_material(0, new_mat)


func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	if state == State.ENDED:
		velocity.z = lerp(velocity.z, 0.0, delta * 0.1)
	
	# or alt to this: forward pressing increases
	#if Input.is_action_just_pressed(input_faster):
		#velocity.z -= delta * 10
		#print("Speed up")
	#elif Input.is_action_just_pressed(input_slower) and velocity.z < 0.0:
		#velocity.z += delta * 10
		#print("Slow down")
	#else:
		#velocity.z = lerp(velocity.z, 0.0, delta * 0.1)
	var dir := get_user_input()
	velocity.z -= delta * dir.x * 10
	velocity.z = clamp(velocity.z, -1000.0, 0.0)
	velocity.x += delta * dir.y * 10
	
	var _res = move_and_slide()

func _on_gamestate_updated(new_gamestate) -> void:
	print("Updated game state to ", new_gamestate, " compared to playing ", FreezeManager.GameState.PLAYING)
	match new_gamestate:
		FreezeManager.GameState.PLAYING:
			state = State.PLAYING
		FreezeManager.GameState.ENDED:
			state = State.ENDED
		_:
			state = State.CUTSCENE


func get_user_input() -> Vector2:
	if state == State.CUTSCENE or state == State.ENDED:
		return Vector2.ZERO
	var input_dir:Vector2
	if player == Player.A:
		input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	else:
		input_dir = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	return input_dir

# TODO: animation functions like:
# play intro then fall
# play wiggle
# play win
# play spinaround
