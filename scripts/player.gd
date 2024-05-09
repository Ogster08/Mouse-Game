extends CharacterBody2D

signal HEALTH_CHANGED

@export var MAX_SPEED = 240
@export var ACCELERATION = 80
@export var JUMP_VELOCITY = -240
@export var JUMP_BUFFER_TIME = 15

@export var MAX_HEALTH = 600
@onready var current_health : float = MAX_HEALTH

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jump_buffer_counter = 0

@onready var point_light_2d = $PointLight2D

func death():
	get_tree().reload_current_scene()
	Engine.time_scale = 1

func sigmoid(x):
	var a = 8
	var b = -0.5
	return 2 / (1 + exp(-a * x + b)) - 1

func change_health(value: float):
	#print(value)
	current_health = clamp(current_health + value, 0, MAX_HEALTH)
	HEALTH_CHANGED.emit()

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
		if velocity.y < 0:
			velocity.y *= 0.5

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x =  clamp(velocity.x + direction * ACCELERATION, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)

	move_and_slide()
	
	
	change_health(-60 * delta)

func _process(delta):
	point_light_2d.texture_scale = sigmoid(current_health / MAX_HEALTH)
	point_light_2d.energy = sigmoid(current_health / MAX_HEALTH)
	
	if current_health <= 0:
		death()
