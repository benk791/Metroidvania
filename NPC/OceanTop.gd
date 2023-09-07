extends TextureRect

func _process(delta):
	position.x += 0.5
	if position.x == 0:
		position.x = -24
