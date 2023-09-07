extends Node



func _on_bridge_jump_left_area_entered(area):
	Global.emit_signal("NewSafePosition", $BridgeJumpLeft.get_transform()[2])


func _on_bridge_jump_right_area_entered(area):
	Global.emit_signal("NewSafePosition", $BridgeJumpRight.get_transform()[2])


func _on_bridge_jump_left_top_area_entered(area):
	Global.emit_signal("NewSafePosition", $BridgeJumpLeftTop.get_transform()[2])
