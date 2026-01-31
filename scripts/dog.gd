extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_h_sensitivity = 0.05;
var mouse_v_sensitivity = 0.05;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED; #mousecaptured


func _physics_process(delta: float) -> void:
	# escape mouse_captured
	
	if Input.is_action_just_pressed("Cancel"):
		print(deg_to_rad($CameraArm.rotation.x));
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward");
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	if direction:
		velocity.x = direction.x * SPEED;
		velocity.z = direction.z * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
		velocity.z = move_toward(velocity.z, 0, SPEED);

	move_and_slide()

#mouse rotations:
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(-event.relative.x * mouse_h_sensitivity)); #rotates the horizontal axis
			$CameraArm.rotate_x(deg_to_rad(-event.relative.y * mouse_v_sensitivity)); #rotates the vertical axis
			$CameraArm.rotation.x = clamp($CameraArm.rotation.x,deg_to_rad(-30),deg_to_rad(0)); #clamps the rotation
