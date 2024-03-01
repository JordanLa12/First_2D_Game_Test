extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const DASH_FORCE = 450

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const GRAVITY = 25

const DOUBLETAP_DELAY = 0.25
var doubletap_time = DOUBLETAP_DELAY
var last_keycode = 0

enum PlayerStates {idle, moving, airborne, dash}
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
	if Input.is_action_pressed("move_jump"):
		state = PlayerStates.airborne
		velocity.y = JUMP_VELOCITY
		
		
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	var direction = Input.get_axis("move_left", "move_right") # On left or right hold inputs multiple inputs like turbo mode, need to fix for touble tap
	if direction: # direction is an int, if ~0/True
		if direction < 0:
			$Sprite2D.flip_h = true
		else: 
			$Sprite2D.flip_h = false
		if is_on_floor():
			state = PlayerStates.moving
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) # Set velocity to 0 
		if is_on_floor():
			state = PlayerStates.idle
		
		
		
	match state: 
		PlayerStates.idle:
			$AnimationTree.set("parameters/Transition/transition_request", "ground")
			$AnimationTree.set("parameters/movement/transition_request", "idle")
		PlayerStates.moving:
			$AnimationTree.set("parameters/movement/transition_request", "walk")
		PlayerStates.airborne:
			$AnimationTree.set("parameters/Transition/transition_request", "air")
			$AnimationTree.set("parameters/in_air/transition_request", "jumping")
		PlayerStates.dash:
			$AnimationTree.set("parameters/Transition/transition_request", "dash")
		
	doubletap_time -= delta
	print("last key code is: " + str(last_keycode))
	print(state)
	
		

	move_and_slide()
	
func _input(event):
	if event is InputEventKey and event.is_released(): # Checks if event is a key type and if it is pressed
		#print(event.as_text()) # Human readable
		#print(event.keycode) # Actual key code
		if event.keycode == KEY_RIGHT or event.keycode == KEY_LEFT:
			#print("last key code is: " + str(last_keycode))
			if last_keycode == event.keycode and doubletap_time >= 0: # if last_keycode same as current, i.e double press and buffer time still active do double tap input, fixed via on_released
				#print("DOUBLETAP: ", String.chr(event.keycode))
				last_keycode = 0
				state = PlayerStates.dash
				velocity.x = DASH_FORCE
				print("velocity is:" + str(velocity.x))
				# Dash cooldown
			else:
				last_keycode = event.keycode
			doubletap_time = DOUBLETAP_DELAY
	print_keycode(event)
	

func print_keycode(event: InputEvent) -> void:
	if event is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		print(OS.get_keycode_string(keycode))

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
	
