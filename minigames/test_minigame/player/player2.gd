extends CharacterBody2D
@export var speed = 400
@export var ogTexture : Texture
@export var otherTexture : Texture
var spriteHalfSize = 64
var changingScene = false
var altSprite = false

func _ready() -> void:
	$Icon.texture = ogTexture

func get_input():	
	var input_direction = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	velocity = input_direction * speed
	
	if Input.is_action_just_pressed("p2_action1"):
		if not altSprite:
			$Icon.texture = otherTexture
			altSprite = true
		else:
			$Icon.texture = ogTexture
			altSprite = false
		
	if Input.is_action_just_pressed("p2_action2"):
		$Icon.flip_v = !$Icon.flip_v
	
func playerInput():
	get_input()
	
	if !changingScene:
		var screenSize = get_viewport()
		position.x = clamp(position.x, spriteHalfSize, screenSize.size.x - spriteHalfSize)
		position.y = clamp(position.y, spriteHalfSize, screenSize.size.y - spriteHalfSize)
		move_and_slide()
	else:
		changingScene = false
