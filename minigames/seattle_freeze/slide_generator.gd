extends Node3D

const Basic = preload("res://minigames/seattle_freeze/segments/basic.tscn")
const Intersection = preload("res://minigames/seattle_freeze/segments/intersection.tscn")
const IntersectionEnd = preload("res://minigames/seattle_freeze/segments/intersection_end.tscn")
const FreezePlayer = preload("res://minigames/seattle_freeze/slide_player.gd")

const Z_MARGIN:float = 20
const Z_MARGIN_DESPAWN:float = 40


@export var prefabs: Array[PackedScene] = [Basic]
@export var debug: bool = false

var players: Array = []
# First vector is the minimum z value (stored in x), with cooresponding y height there
# Second is the max z value (stored in x), wit h the corresponding y height there
var seg_bounds: Array[Vector2]
var segs_added := 0

const min_segments := 5
const intersection_freq := 5


func _ready() -> void:
	add_first_segment()
	for ch in get_parent().get_children():
		if ch is FreezePlayer:
			players.append(ch)
	if not players:
		push_error("Could not identify any freeze slide players")


func _physics_process(_delta: float) -> void:
	if not players:
		return
	
	var seg_min_z:Vector2 = seg_bounds[0]
	var seg_max_z:Vector2 = seg_bounds[1]
	var player_zs := player_z_positions()
	var player_min_z:float = player_zs.min()
	var player_max_z:float = player_zs.max()

	if get_child_count() == 0:
		# Awaiting for _ready()
		return
	# Compare to current position to see where players are.
	if abs(player_min_z - seg_min_z.x) < Z_MARGIN:
		if debug:
			print(player_min_z, " vs ", Z_MARGIN, " vs ", seg_min_z.x)
		add_segment()
	
	# Look at furthest back segment to see about deleting it
	var del_seg:Node3D = get_child(0)
	if abs(seg_max_z.x - player_max_z) > Z_MARGIN_DESPAWN:
		del_seg.queue_free()
		seg_bounds = get_bounds()


func player_z_positions() -> Array[float]:
	var zpos: Array[float] = []
	for _player in players:
		zpos.append(_player.global_position.z)
	return zpos


func get_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	if get_child_count() == 0:
		return []
	for _ch:Path3D in get_children():
		var res := get_curve_bounds(_ch)
		var min_z: Vector2 = res[0]
		var max_z: Vector2 = res[1]
		if bounds == []:
			bounds = res
			continue
		if bounds[0].x > min_z.x:
			bounds[0].x = min_z.x
			bounds[0].y = min_z.y
		if bounds[1].x < max_z.x:
			bounds[1].x = max_z.x
			bounds[1].y = max_z.y
	return bounds


func get_curve_bounds(path: Path3D) -> Array[Vector2]:
	var min_z: Vector2
	var max_z: Vector2
	var first_assign := true
	for pts in range(path.curve.point_count):
		var pos: Vector3 = path.curve.get_point_position(pts)
		var posg: Vector3 = path.to_global(pos)
		if first_assign or posg.z < min_z.x:
			min_z.x = posg.z
			min_z.y = posg.y
		if first_assign or posg.z > max_z.x:
			max_z.x = posg.z
			max_z.y = posg.y
		first_assign = false
	
	if max_z.x - min_z.x > 11:
		push_warning("Should not have larger than 10 offset for path, difference of %s" % (max_z.x - min_z.x))
	return [min_z, max_z]


func add_first_segment() -> void:
	segs_added += 1
	var seg = Intersection.instantiate()
	add_child(seg)
	# Set any animation timers etc..?
	# signal the scene being ready..?
	seg_bounds = get_bounds()


func add_segment() -> void:
	if debug:
		print("Add segment!")
	segs_added += 1
	var prior_seg = get_child(-1)
	
	var to_spawn:PackedScene
	if segs_added > 1 and segs_added % intersection_freq == 0:
		#check if game should end now
		if get_parent().check_remaining_time_msec() < 0:
			to_spawn = IntersectionEnd
		else:
			to_spawn = Intersection
	else:
		to_spawn = prefabs[randi() % prefabs.size()]
	
	var instance = to_spawn.instantiate()
	add_child(instance)
	# now placement of this child based on prior child
	
	var prior_bounds := get_curve_bounds(prior_seg)
	var new_bounds := get_curve_bounds(instance)
	if debug:
		print("\tprior child: ", prior_seg, " bounds ", prior_bounds)
		print("\tnew child: ", instance, " bounds ", new_bounds)
	var prior_minz: Vector2
	var new_maxz: Vector2
	for val in prior_bounds:
		if prior_minz == null or prior_minz.x > val.x:
			prior_minz = val
	for val in new_bounds:
		if new_maxz == null or new_maxz.x < val.x:
			new_maxz = val
	if debug:
		print("\tvalue z: ", prior_minz, " vs ", new_maxz)
	instance.global_position.z = prior_minz.x - new_maxz.x
	instance.global_position.y = prior_minz.y - new_maxz.y
	# Assumes prior segment is centered at its origin (otherwise, need to offset by global_position.x/y from next maxz
	#instance.global_position.z = prior_seg.global_position.z + prior_minz.x
	#instance.global_position.y = prior_seg.global_position.y + prior_minz.y
	if debug:
		print("\tfinal output: ", instance.global_position)
	
	seg_bounds = get_bounds()
	
