extends Area2D

var Pickup = false

func _ready():
	Global.connect("Interact", interact)
	$AnimatedSprite2D.play("default")

func interact():
	if Pickup == true:
		Global.UpgradeWallJump = true
		$AnimatedSprite2D.visible = false
		$PickupSound.play()

func _on_area_entered(area):
	Pickup = true

func _on_area_exited(area):
	Pickup = false

func _on_pickup_sound_finished():
	self.queue_free()
