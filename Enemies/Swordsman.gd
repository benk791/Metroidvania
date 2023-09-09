extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var action = 0
var ChooseAction = true
var SPEED = 40
var actionTimer = 2


func _physics_process(delta):
	print(ChooseAction)
	print(action)
	if ChooseAction == true:
		if action == 0:
			$AnimatedSprite2D.play("idle")
			await get_tree().create_timer(actionTimer).timeout
			action = randi_range(0, 2)
			ChooseAction = true

		if action == 1:
			ChooseAction = false
			$AnimatedSprite2D.play("Overhead1")

		if action == 2:
			#$AnimatedSprite2D.play("idle")
			#ChooseAction = false
			#position.x += 10
			#action = 0
			#ChooseAction = true
			pass

	if (["Overhead2"].has($AnimatedSprite2D.animation)):
		velocity.x = SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _on_animated_sprite_2d_animation_finished():
	if (["Overhead1"].has($AnimatedSprite2D.animation)):
		$AnimatedSprite2D.play("Overhead2")
	if (["Overhead2"].has($AnimatedSprite2D.animation)):
		$AnimatedSprite2D.play("Overhead3")
	if (["Overhead3"].has($AnimatedSprite2D.animation)):
		action = 0
		ChooseAction = true
