extends CharacterBody2D

const MAX_SPEED = 240
const ACCELERATION = 100
const JUMP_VELOCITY = -240
const JUMP_BUFFER_TIME = 15
# set gravity to 50 * size

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_counter = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_TIME
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0  and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump"):
		if velocity.y < -120:
			velocity.y += 200

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x =  clamp(velocity.x + direction * ACCELERATION, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)

	move_and_slide()
	print(velocity.y)
