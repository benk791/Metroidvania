extends Control


@onready var DeathMenu = $"."

func _ready():
	DeathMenu.visible = false
	Global.connect("dead", dead)

func dead():
	DeathMenu.visible = true
	$DeathNoise.play()
	get_tree().paused = true

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_respawn_pressed():
	Global.emit_signal("PlayerDestroy")
	Global.emit_signal("PlayerRespawn")
