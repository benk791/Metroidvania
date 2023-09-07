extends TextureRect

func _process(delta):
	position.x += 1
	if position.x == 0:
		position.x = -48
