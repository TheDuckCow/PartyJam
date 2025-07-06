extends Sprite3D

@onready var timer:Timer = Timer.new()

var max_frames = 1

func _ready() -> void:
	add_child(timer)
	timer.autostart
	timer.timeout.connect(_timer_update)
	max_frames = hframes * vframes
	timer.start(0.3)
	
	
func _timer_update() -> void:
	print("Reproter timer update")
	frame = randf_range(0, max_frames-1)
	timer.wait_time = 0.3 + 0.2 * randf()
	timer.start(timer.wait_time)
