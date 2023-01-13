extends KinematicBody2D

var dashcooldown = 0
const speed = 200
const gravity = 15
const no_gravity = 0
const dash_speed = 600
const dash_duration = 0.18
var speediness = speed
var grav = gravity
var jump_force = 400
var dashes = 1
var jumps = 1
var jumping = false
var velocity = Vector2.ZERO
var spawnPoint = Vector2.ZERO
var groundedDash = false
var left = false
var right = false
var direction = 'none'
var up_dash = false


onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var dash = $Dash
	
func _physics_process(delta):
	velocity.y += grav
	if is_on_floor():
		dashes = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speediness
		sprite.set_flip_h(true)
		animation.play("Run")
		left = true
	elif Input.is_action_just_released("ui_left"):
		left = false
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speediness
		sprite.set_flip_h(false)
		animation.play("Run")
		right = true
	elif Input.is_action_just_released("ui_right"):
		right = false
	else:
		velocity.x = 0	
		animation.play("Idle")
	if velocity.y > 0: 
		pass
	elif velocity.y < 0 && Input.is_action_just_released("ui_up"): 
		velocity += Vector2.UP * (-9.81) * (15)
		jumping = false
		
	if Input.is_action_pressed("up_dash"):
		up_dash = true
	else:
		up_dash= false
		
	if is_on_floor() or nextToWall():
		jumps = 1
		if Input.is_action_pressed(("ui_down")):
			#animation.play("Crouched")
			pass
		if Input.is_action_just_pressed("ui_up") && jumps==1:
			jumping = true
			jumps -= 1
			velocity = Vector2(0, -jump_force)
			if not is_on_floor() && nextToLeftWall():
				velocity.x += 150
				velocity.y -= 33
			if not is_on_floor() && nextToRightWall():
				velocity.x -= 150
				velocity.y -= 33
		elif Input.is_action_just_released("ui_up"):
			jumping = false
	else:
		#animation.play("jump")
		pass
	if Input.is_action_just_pressed("dash") && dashes == 1 && dashcooldown ==0 :
		dash.start_dash(dash_duration)
		dashes -= 1
		dashcooldown = 20000
		if is_on_floor():
			groundedDash = true
		else:
			groundedDash = false
		if !sprite.flip_h && ((groundedDash && !up_dash) || (!groundedDash && !up_dash)): 
			direction = 'right'
		elif !sprite.flip_h && up_dash:
			direction = 'upright'
		elif sprite.flip_h && ((groundedDash && !up_dash) || (!groundedDash && !up_dash)):
			direction = 'left'
		elif sprite.flip_h && up_dash:
			direction = 'upleft'
		for i in range(dashcooldown):
			dashcooldown -=1
		print(dashcooldown)
	if dash.is_dashing():
		if direction == 'right': 
			velocity.x += dash_speed
		elif direction == 'upright':
			velocity = Vector2(dash_speed, -dash_speed)
		elif direction == 'upleft':
			velocity = Vector2(-dash_speed, -dash_speed)
		elif direction == 'left':
			velocity.x -= dash_speed
		grav = no_gravity
	else:
		grav = gravity
		speediness = speed
	if dash.timeout:
		velocity.y = 0
	else:
		pass
	velocity = move_and_slide(velocity, Vector2.UP)
	
func nextToWall():
	return nextToLeftWall() or nextToRightWall()
	
func nextToLeftWall():
	return $LeftWall.is_colliding() or $LeftWall2.is_colliding() or $LeftWall3.is_colliding()
	
func nextToRightWall():
	return $RightWall.is_colliding() or $RightWall2.is_colliding() or $RightWall3.is_colliding()

func _on_HurtBox_area_entered(area):
	self.position = spawnPoint
		
func _on_SpawnPoint1_area_entered(area):
	spawnPoint = Vector2(position.x, position.y)

func _on_SpawnPoint2_area_entered(area):
	spawnPoint = Vector2(position.x, position.y)



