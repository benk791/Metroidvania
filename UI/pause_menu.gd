extends Control

@onready var pauseMenu = $"."
signal respawn
var inMenu = false
func _ready():
	pauseMenu.visible = false

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		pauseMenu.visible = true
		get_tree().paused = true
		if Input.is_action_just_pressed("escape") and inMenu:
			pauseMenu.visible = false
			get_tree().paused = false
			inMenu = false
		else:
			inMenu = true

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_resume_pressed():
	pauseMenu.visible = false
	get_tree().paused = false
	inMenu = false

func _on_respawn_pressed():
	Global.emit_signal("PlayerDestroy")
	Global.emit_signal("PlayerRespawn")
