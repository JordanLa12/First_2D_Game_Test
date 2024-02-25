extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0
# @onready var _animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimationTree.active = true

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#$AnimationTree.set("parameters/movement/transition_request", "fall")

	# Handle jump.
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationTree.set("parameters/movement/transition_request", "jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	#var direction = Input.get_axis("move_left", "move_right")
	#if direction: # direction is an int, if ~0/True
		#velocity.x = direction * SPEED
		#print(direction)
		#print(velocity.x)
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED) # Set velocity to 0 
		#$Sprite2D.flip_h = true
		
	if Input.is_action_pressed("move_left"):
		velocity.x = -1.0 * SPEED
		$Sprite2D.flip_h = true
		$AnimationTree.set("parameters/movement/transition_request", "walk")
	elif Input.is_action_pressed("move_right"):
		velocity.x = 1.0 * SPEED
		$Sprite2D.flip_h = false
		$AnimationTree.set("parameters/movement/transition_request", "walk")
	else:
		velocity.x = 0
		$AnimationTree.set("parameters/movement/transition_request", "idle") # This replaces the jump animations
		
		

	move_and_slide()
