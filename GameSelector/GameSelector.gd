extends Node2D

const LEVEL_BTN = preload("res://GameSelector/LevelButton.tscn")

@export_dir var dirPath

@onready var grid = $LevelList/ScrollContainer/GridContainer

func _ready() -> void:
	get_levels(dirPath)

func get_levels(path) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				create_level_btn("%s/%s" % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
	elif dir == null:
		print("An error occured when trying to open path", path)

func create_level_btn(lvlPath: String, lvlName: String) -> void:
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvlName.trim_suffix('.tscn')
	btn.level_path = lvlPath
	grid.add_child(btn)
