extends Node3D

const Basic = preload("res://minigames/seattle_freeze/segments/basic.tscn")

@export var prefabs: Array[PackedScene] = [Basic]

func _physics_process(delta: float) -> void:
	
	var bounds := get_bounds()
	if bounds == Vector2.ZERO:
		add_segment()


func get_bounds() -> Vector2:
	var bounds: Vector2
	if get_child_count() == 0:
		return Vector2.ZERO
	for _ch:Path3D in get_children():
		var res := get_curve_bounds(_ch)
		#print("Bounds of this instance")
		var min_z: float = res[0]
		var max_z: float = res[0]
	
	return bounds

func get_curve_bounds(path: Path3D) -> Array[float]:
	var min_z: float
	var max_z: float
	for pts in path.curve.point_count:
		var pos: Vector3 = path.curve.get_point_position(0)
		var posg: Vector3 = path.to_global(pos)
		if min_z == null or posg.z < min_z:
			min_z = posg.z
		if max_z == null or posg.z > max_z:
			max_z = posg.z
	return [min_z, max_z]

func add_segment() -> void:
	print("Add segment!")
	var to_spawn:PackedScene = prefabs[randi() % prefabs.size()]
	var instance = to_spawn.instantiate()
	add_child(instance)
	# now placement of this child based on prior child
	
	var prior_seg = get_child(-1)
	print("prior child: ", prior_seg)
	
