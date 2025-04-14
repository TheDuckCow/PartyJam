extends Button

@export_dir var dirPath
var games = []

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
