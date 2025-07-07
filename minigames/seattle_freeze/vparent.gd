extends Node3D

@export var vparent: Node3D

var init_offset := Vector3.ZERO


func _ready() -> void:
	init_offset = global_position - vparent.global_position

func _process(_delta: float) -> void:
	global_position = vparent.global_position + init_offset
