extends Sprite3D

var last_spin:int = 0

func _ready() -> void:
	#_update_frame_for_angle()
	_alt_update_frame_for_angle()


func _alt_update_frame_for_angle() -> void:
	var cam: Camera3D = get_viewport().get_camera_3d()
	var to_camera = cam.global_transform.origin - self.global_transform.origin
	to_camera.y = 0
	to_camera = to_camera.normalized()
	
	var forward = -self.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	
	var angle = forward.signed_angle_to(to_camera, Vector3.UP) # angle in radians
	#print("THe angle is: ", rad_to_deg(angle))
	var ang_deg = rad_to_deg(angle) - 0 # offset for frame cycle
	var mod = roundi(ang_deg / 45)
	frame = 7 - (mod + 3)


func _update_frame_for_angle() -> void:
	var cam: Camera3D = get_viewport().get_camera_3d()
	var camz := cam.global_basis.z
	var suvz := global_basis.z
	var cross := global_basis.z.cross(cam.global_basis.z)
	#print("CRossed angle: ", cross)
	var ang := camz.angle_to(suvz)
	#print("Angle: ", ang)
	

func _physics_process(delta: float) -> void:
	#_test_rotation()
	pass


func _test_rotation() -> void:
	var curtime := Time.get_ticks_msec()
	if curtime - last_spin > 400:
		last_spin = curtime
		self.get_parent().rotate_y(PI/4)
		print("Rotate!")
		#_update_frame_for_angle()
		_alt_update_frame_for_angle()
