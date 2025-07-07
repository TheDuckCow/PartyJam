extends Node3D

@export var bump_player: AudioStreamPlayer

func play_carbump() -> void:
	bump_player.play()
