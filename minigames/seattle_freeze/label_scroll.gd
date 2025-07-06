extends Label


func _ready() -> void:
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
	var tmp = text + text + text
	text = tmp


func _on_resize() -> void:
	# Ended up not needing since it's full width anyways, but could use this
	# to crop in a fragmetn (not vertex) shader.
	# Original shader mostly from:
	# https://forum.godotengine.org/t/horizontally-scrolling-dynamicfont-shader/13446/2
	var size:Vector2 = get_viewport().get_visible_rect().size
	print("Window did resize %s" % size.x)
	#self.material.set_shader_parameter("TextWidth", size.x)
