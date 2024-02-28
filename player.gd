extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const GRAVITY = 25

enum PlayerStates {idle, moving, airborne}
var state = PlayerStates.idle

func _ready():
	$AnimationTree.active = true

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
		if velocity.y > 1000:
			velocity.y = 1000
		#$AnimationTree.set("parameters/movement/transition_request", "fall")

	# Handle jump.
	if Input.is_action_just_pressed("move_jump"):
		state = PlayerStates.airborne
		velocity.y = JUMP_VELOCITY
		
		
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	var direction = Input.get_axis("move_left", "move_right")
	if direction: # direction is an int, if ~0/True
		if direction < 0:
			$Sprite2D.flip_h = true
		else: 
			$Sprite2D.flip_h = false
		#if is_on_floor():
			#state = PlayerStates.moving
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) # Set velocity to 0 
		if is_on_floor():
			state = PlayerStates.idle
		
		
		
	match state: 
		PlayerStates.idle:
			$AnimationTree.set("parameters/movement/transition_request", "idle")
		PlayerStates.moving:
			$AnimationTree.set("parameters/movement/transition_request", "walk")
		PlayerStates.airborne:
			$AnimationTree.set("parameters/in_air/transition_request", "jump")
		
	
	print(state)
		

	move_and_slide()

func walk(): 
	if is_on_floor():
		velocity.x = 0
		$AnimationTree.set("parameters/movement/transition_request", "idle") # This replaces the jump animations
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -1.0 * SPEED
		$Sprite2D.flip_h = true
		$AnimationTree.set("parameters/movement/transition_request", "walk")
	elif Input.is_action_pressed("move_right"):
		velocity.x = 1.0 * SPEED
		$Sprite2D.flip_h = false
		$AnimationTree.set("parameters/movement/transition_request", "walk")
	
func gravity():
	pass

func jump():
	pass

func crouch():
	pass
	# enable CollisionShape2DCrouch
	# disable collisionShape2DStand
	
func dash():
	pass
	# Should work in air too
	
