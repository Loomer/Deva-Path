extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.03


@onready var head = $Head
@onready var camera = $Head/Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
	
	
	# clamping camera movement, Take x axis variable (for lack of a better term) and apply the rotation fuction to it
	camera.rotation.x = clamp(
		camera.rotation.x,
		deg_to_rad(-80),
		deg_to_rad(80)
	)
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "foward", "back")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	if Input.is_action_just_pressed("ui_cancel"): 	# This bit of code is just to easily exit when running the scene
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # let's you press esc to see your cursor again so you can quit the window
		# It's usually inserted after the code below (the commented code)
		#func _ready():
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		

	move_and_slide()
