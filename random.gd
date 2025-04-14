extends Button

@export_dir var dirPath
var games = []

var oSize := scale
var grow_size := Vector2(1.1, 1.1)

func _on_mouse_entered() -> void:
	grow_btn(grow_size, .1)

func _on_mouse_exited() -> void:
	grow_btn(oSize, .1)

func grow_btn(end_size: Vector2, duration: float) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', end_size, duration)

func _ready() -> void:
	var dir = DirAccess.open(dirPath)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				addGame(file_name)
			file_name = dir.get_next()
	else:
		print("An error occured when trying to open path")

func addGame(filepath: String):
	games.append(filepath)

func random():
	var randomGameIndex = randi() % games.size()
	print("Num of games: ", games.size(),  "  Random number: ", randomGameIndex, " Game: ", dirPath + "/" + games[randomGameIndex])
	get_tree().change_scene_to_file(dirPath + "/" + games[randomGameIndex])

func _on_pressed() -> void:
	random()
