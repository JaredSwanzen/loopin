extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready
var ray = $RayCast2D
var key = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if key:
			key.set_position(Vector2(20 * -direction, 0))
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("pick_up_objects"): #Add the key and its parent to this group along with any collision shap that come with it
			add_key(collision.get_collider())
	if ray.get_collider():
		var collided = ray.get_collider()
		if collided.is_in_group("crushable"):
			crush_object(collided)
			
func add_key(object):
	var parent = object.get_parent()
	var child = object.get_child(0, true)
	object.remove_child(child)
	parent.remove_child(object)
	self.add_child(child)
	key = child
	
func crush_object(object):
	for index in object.get_child_count():
		var child = object.get_child(index, true)
		child.scale = Vector2(child.scale.x, 0.1)
	object.remove_from_group("crushable")
		
		
			
