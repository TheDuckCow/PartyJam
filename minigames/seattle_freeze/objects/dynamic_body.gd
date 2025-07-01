extends CharacterBody3D

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")
const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")

@onready var raycast:RayCast3D = $RayCast3D

var GRAVITY:float = ProjectSettings.get_setting("physics/3d/default_gravity")


var dislodged := false

var input_faster: String
var input_slower: String


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	if dislodged:
		velocity.z -= delta * 5
		velocity.z = clamp(velocity.z, -1000.0, 0.0)
	
	var _res = move_and_slide()
	
	var n := raycast.get_collision_normal()
	print("Normal: ", n)
	var xform := align_with_y(global_transform, n.normalized())
	global_transform = global_transform.interpolate_with(xform, 12 * delta)


func align_with_y(xform:Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	#xform.basis = xform.basis.orthonormalized()
	xform.orthonormalized()
	return xform


func _on_body_entered(body: Node3D) -> void:
	if body == self:
		# Area is around the characyer shape itself
		return
	if not body is CharacterBody3D:
		return
	
	if not dislodged:
		dislodged = true
		self.velocity = body.velocity
		# compare the horizontal velocity, add that some?
		body.velocity = Vector3.ZERO
		if body is FreezePlayer:
			print("Consider zero-setting and penalty assign player")
	elif body.global_position.z < self.global_position.z:
		# Body is downhill of the car, and thus is being "dmanaged"
		#body.velocity.x = 2 * randi_range(-1, 1)
		if body is FreezePlayer:
			print("Consider penalty assign player for SUV hit")
