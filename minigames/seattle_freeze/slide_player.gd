extends CharacterBody3D

var GRAVITY:float = ProjectSettings.get_setting("physics/3d/default_gravity")


enum State {INTRO, PLAYING, OUTRO}
enum Player {A, B}
@export var state: State = State.PLAYING
@export var player: Player = Player.A

var input_faster: String
var input_slower: String

func _ready() -> void:
	match player:
		Player.A:
			input_faster = "p1_action2"
			input_slower = "p1_action1"
		Player.B:
			input_faster = "p2_action2"
			input_slower = "p1_action1"


func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
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


func get_user_input() -> Vector2:
	var input_dir:Vector2
	if player == Player.A:
		input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	else:
		input_dir = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	return input_dir
