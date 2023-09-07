extends CanvasLayer


@onready var main = $main
@onready var settings = $settings

func _ready():
	main.visible = true
	settings.visible = false

func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/level 1/level_1.tscn")

func _on_settings_pressed():
	main.visible = false
	settings.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_setting_back_pressed():
	main.visible = true
	settings.visible = false

func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
