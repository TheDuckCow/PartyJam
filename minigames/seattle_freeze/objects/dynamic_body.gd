extends CharacterBody3D

signal on_collide

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")
const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")

@onready var raycast:RayCast3D = $RayCast3D

var GRAVITY:float = ProjectSettings.get_setting("physics/3d/default_gravity")

var dislodged := false
var input_faster: String
var input_slower: String

var cam: Camera3D

func _ready() -> void:
	# Avoid being queued free with segments
	#reparent(get_parent().get_parent(), true)
	# TODO: actually reparent this to somewhere
	# that can't be despawend.
	cam = get_viewport().get_camera_3d()
	
	if randf() > 0.5:
		self.rotate_y(PI)


func _physics_process(delta: float) -> void:
	if cam.global_position.y - self.global_position.y > 70:
		#queue_free()
		pass
	velocity.y -= GRAVITY * delta
	if dislodged:
		velocity.z -= delta * 5
		velocity.z = clamp(velocity.z, -1000.0, 0.0)
	
	var _res = move_and_slide()
	
	var n := raycast.get_collision_normal()
	if n != Vector3.ZERO: # if nothing hit, will be Vector3.ZERO
		var xform := align_with_y(global_transform, n.normalized())
		global_transform = global_transform.interpolate_with(xform, 12 * delta)


func align_with_y(xform:Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	return xform


func _on_body_entered(body: Node3D) -> void:
	if body == self:
		# Area is around the characyer shape itself
		return
	if not body is CharacterBody3D:
		return
	
	if not dislodged:
		dislodged = true
		on_collide.emit()
		self.velocity = body.velocity
		# compare the horizontal velocity, add that some?
		body.velocity = Vector3.ZERO
		if body is FreezePlayer:
			#print("Consider zero-setting and penalty assign player")
			pass
	elif body.global_position.z < self.global_position.z:
		# Body is downhill of the car, and thus is being "dmanaged"
		#body.velocity.x = 2 * randi_range(-1, 1)
		if body is FreezePlayer:
			#print("Consider penalty assign player for SUV hit")
			pass
