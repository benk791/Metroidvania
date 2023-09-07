extends Area2D

var delay = false
var time = 0

func _ready():
	$Attack.visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		delay = true
	
	if delay == true:
		time += delta
	
	if time >= 0.125:
		$Attack.visible = true
		$Attack.play("kick")
		delay = false
		time = 0

func _on_attack_animation_finished():
	$Attack.visible = false
