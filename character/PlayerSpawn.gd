extends Node2D

var Player = preload("res://character/character.tscn")

func _ready():
	Global.connect("PlayerRespawn", respawn)
	Global.connect("PlayerDestroy", destroy)
	respawn()

func destroy():
	if self.get_child_count() > 0:
		self.get_child(0).queue_free()

func respawn():
	Global.PlayerHealth = Global.maxPlayerHealth
	var Player_instance = Player.instantiate()
	Player_instance.position = Vector2(44,1000)/2
	self.add_child(Player_instance)
	get_tree().paused = false
