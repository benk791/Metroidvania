extends Area2D

func _on_area_entered(area):
	Global.emit_signal("Refocus", 2496, -96, 3456, 448)


func _on_area_exited(area):
	Global.emit_signal("Refocus", 0, -10000000, 10000000, 1088)
