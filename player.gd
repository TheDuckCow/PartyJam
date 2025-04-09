extends CharacterBody2D
@export var speed = 400
var spriteHalfSize = 64
var changingScene = false

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = input_direction * speed
	
	if Input.is_action_pressed("esc"):
		print("Escape key pressed")
		get_tree().change_scene_to_file("res://menu.tscn")
		changingScene = true
	
func _physics_process(_delta):
	get_input()
	
	if !changingScene:
		var screenSize = get_viewport()
		position.x = clamp(position.x, spriteHalfSize, screenSize.size.x - spriteHalfSize)
		position.y = clamp(position.y, spriteHalfSize, screenSize.size.y - spriteHalfSize)
		move_and_slide()
	else:
		changingScene = false
