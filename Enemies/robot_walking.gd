extends CharacterBody2D


const SPEED = 40

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = (randi_range(0, 1)-0.5)*2

func _ready():
	$RobotSprites.play("step")

func _physics_process(delta):
	var adjustment = -1**(snappedf(rotation_degrees, 1)/180)

	if not $leftFoot.is_colliding() or $leftFace.is_colliding():
		direction = 1 * adjustment
	if not $rightFoot.is_colliding() or $rightFace.is_colliding():
		direction = -1 * adjustment
	
	animation(direction, adjustment)
	
	if (["move"].has($RobotSprites.animation)):
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func animation(direction, adjustment):
	if direction * adjustment > 0:
		$RobotSprites.flip_h = true
	if direction * adjustment < 0:
		$RobotSprites.flip_h = false

func _on_robot_sprites_animation_finished():
	if (["step"].has($RobotSprites.animation)):
		$RobotSprites.play("move")
	elif (["move"].has($RobotSprites.animation)):
		$RobotSprites.play("return")
	elif (["return"].has($RobotSprites.animation)):
		$RobotSprites.play("step")
