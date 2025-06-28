extends Control

const FreezeManager = preload("res://minigames/seattle_freeze/seattle_freeze_manager.gd")

@export var time_remaining: Label

@onready var manager:FreezeManager = get_parent()

func _process(delta: float) -> void:
	var time_left := manager.check_remaining_time_msec() / 1000.0
	var new_text := "%0.2f s" % time_left
	time_remaining.text = new_text
