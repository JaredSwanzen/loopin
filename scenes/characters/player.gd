extends CharacterBody2D

var SPEED = 200.0
var JUMP_VELOCITY = -400.0
const BABY_COLLISION = [10,38]
const ADULT_COLLISION = [13, 48]

var age;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAnimation=""

func _physics_process(delta):
	age = get_parent().current_age
	
	if age == "child":
		$CollisionShape2D.shape.radius = 10
		$CollisionShape2D.shape.height = 31
		$Body.scale = Vector2(0.8,0.8)
	else:
		$CollisionShape2D.shape.radius = 15
		$CollisionShape2D.shape.height = 62
		$Body.scale = Vector2(1.2,1.2)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and age == 'adult':
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			if is_on_floor():
				currentAnimation = "%s_walk_right" % age
				animateCharacter(currentAnimation)			
			else:
				if not velocity.y > 0:
					currentAnimation = "%s_jump_right" % age
					animateCharacter(currentAnimation)			
		else:
			if is_on_floor():
				currentAnimation = "%s_walk_left" % age
				animateCharacter(currentAnimation)				
			else:
				if not velocity.y > 0:
					currentAnimation = "%s_jump_left" % age
					animateCharacter(currentAnimation)				
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			currentAnimation = "%s_idle" % age
			animateCharacter(currentAnimation)	
		else:
			if velocity.y > 0:
				currentAnimation = "%s_falling" % age
				animateCharacter(currentAnimation)
	
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i);
		if collision:
			emit_signal("mouse_entered",collision);
	
func animateCharacter(animationName):
	if age != "child":
		$Body.play(animationName)
		$Head.play(animationName)
		$Pants.play(animationName)
		$Shirt.play(animationName)
		$Hair.play(animationName)
		$Shoes.play(animationName)
	else:
		$Body.play(animationName)
		$Head.hide()
		$Pants.hide()
		$Shirt.hide()
		$Hair.hide()
		$Shoes.hide()


func _on_next_level_body_entered(body):
	position = Vector2(30, 594);
	if get_parent().current_level == 6:
		get_parent().current_level = 1
	else:
		get_parent().current_level += 1
	
