extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animatedSprite = $PlayerSprites
@export_range(0, 1, 0.01) var JUMP_BUFFER_TIMER : float = 0.1

const SPEED = 200
const JUMP_VELOCITY = -450
const terminalVelocity = 500
const wallSlide = 100 
const wallJumpV = -100
const wallJumpH = 300
const maxGraceTime = 0.08
const trueIdle = 1000

var canJump = true
var shouldJump = false
var graceTimer = 0
var jumped = false
var animationLocked = false
var moveLock = false
var kickCheck = 0
var canKick = true
var holdingWall = false
var knockbackDirection = 1
var lastSafePos = Vector2(44, 1000)
var idleTime = 0
var zoom = 2

func _ready():
	Global.connect("Refocus", onRoomTransition)
	Global.connect("NewSafePosition", NewSafePosition)

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	holdingWall = false
	if Input.is_action_just_pressed("up"):
		Global.emit_signal("Interact")

	# Horizontal velocity
	if not moveLock:
		if direction:
			if abs(velocity.x) <= SPEED:
				velocity.x += direction * SPEED * 0.1
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)

	# Dropping through platforms
	if not moveLock:
		if Input.is_action_just_pressed("down") and is_on_floor():
			self.position.y = self.position.y + 1

	# Wall Jumps
	if Global.UpgradeWallJump == true:
		wallJump(delta)

	# Add gravity
	if not is_on_floor() and not holdingWall:
		if velocity.y < terminalVelocity:
			velocity.y += gravity * delta
		else:
			velocity.y = terminalVelocity
		if jumped == false:
			graceTimer += delta
		else:
			canJump = false

	#canJump
	if is_on_floor():
		canJump = true
		jumped = false
		graceTimer = 0
	if graceTimer > maxGraceTime:
		canJump = false


# Handle Jump.
	if not moveLock:
		if (Input.is_action_just_pressed("jump") or shouldJump):
			if canJump:
				velocity.y = JUMP_VELOCITY
				$Sounds/Jump.play()
				jumped = true
			else:
				buffer_jump()

# allow short jump
	if Input.is_action_just_released("jump"):
		jump_cut()

#attacks
	if Input.is_action_just_pressed("attack") and canKick:
		$Sounds/Kick.play()
		canKick = false
		if kickCheck == 0:
			animatedSprite.play("kick")
			kickCheck = 1
		elif kickCheck == 1:
			animatedSprite.play("kick2")
			kickCheck = 0
		animationLocked = true
		if is_on_floor():
			moveLock = true

	if moveLock:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)

	# Knockback Direction
	if $enemyDetection/EDLeftBottom.is_colliding() or $enemyDetection/EDLeftTop.is_colliding():
		knockbackDirection = 1
	if $enemyDetection/EDRightBottom.is_colliding() or $enemyDetection/EDRightTop.is_colliding():
		knockbackDirection = -1

	animation(direction)
	cameraZoom()
	move_and_slide()

func cameraZoom():
	if idleTime > trueIdle:
		if $Camera2D.get_zoom() < Vector2(5, 5):
			$Camera2D.set_zoom(Vector2(zoom, zoom))
			zoom *= 1.01
	else:
		if $Camera2D.get_zoom() > Vector2(2, 2):
			$Camera2D.set_zoom(Vector2(zoom, zoom))
			zoom /= 1.01

func jump_cut():
	if velocity.y < -100:
		velocity.y = -100

func buffer_jump() -> void:
	shouldJump = true
	await get_tree().create_timer(JUMP_BUFFER_TIMER).timeout
	shouldJump = false

func wallJump(delta):
	if is_on_wall_only() and ($raycastLeft.is_colliding() or $raycastRight.is_colliding()):
		if ($raycastLeft.is_colliding() and Input.is_action_pressed("left")) or ($raycastRight.is_colliding() and Input.is_action_pressed("right")):
			holdingWall = true
			if velocity.y > 0:
				if velocity.y < wallSlide:
					velocity.y += 0.25 * gravity * delta
				else:
					velocity.y = wallSlide
			else:
				velocity.y += gravity * delta
		canJump = true
		jumped = false
		graceTimer = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = wallJumpV
			if $raycastLeft.is_colliding():
				velocity.x = wallJumpH
			if $raycastRight.is_colliding():
				velocity.x = -wallJumpH

func animation(direction):
	if velocity != Vector2.ZERO:
		idleTime = 0
	if not animationLocked:
		if holdingWall:
			if Global.UpgradeWallJump == true:
				if velocity.y >= 0:
					animatedSprite.play("onWall")
				if velocity.y < 0:
					animatedSprite.play("onWallUp")
		elif not is_on_floor():
			if velocity.y > 0:
				if velocity.x != 0:
					animatedSprite.play("fallingMotion")
				else:
					animatedSprite.play("fallingNeutral")
			if velocity.y < 0:
				animatedSprite.play("risingMotion")
		elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				animatedSprite.play("run")
		else:
			animatedSprite.play("idle")
			idleTime += 1
	if Input.is_action_just_pressed("left"):
		animatedSprite.flip_h = true
	if Input.is_action_just_pressed("right"):
		animatedSprite.flip_h = false

func _on_animated_sprite_2d_animation_finished():
	if(["kickReturn", "kick2Return"].has(animatedSprite.animation)):
		animationLocked = false
	if(["kick"].has(animatedSprite.animation)):
		animatedSprite.play("kickReturn")
		moveLock = false
		canKick = true
	if(["kick2"].has(animatedSprite.animation)):
		animatedSprite.play("kick2Return")
		moveLock = false
		canKick = true

func _on_hazard_detection_body_entered(body):
	Global.emit_signal("hurt", 1)
	position = lastSafePos/2

func _on_enemy_detection_body_entered(body):
	Global.emit_signal("hurt", 1)
	$Sounds/Shock.play()
	velocity.y = -200
	velocity.x = knockbackDirection * 300

func onRoomTransition(left, top, right, bottom):
	$Camera2D.limit_left = left
	$Camera2D.limit_top = top
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom

func NewSafePosition(position):
	lastSafePos = position
