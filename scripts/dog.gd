extends CharacterBody3D

signal start_idle();
signal start_run();
signal start_jump();

const SPEED = 5.0;
const JUMP_VELOCITY = 6;
var mouse_h_sensitivity = 0.05;
var mouse_v_sensitivity = 0.05;
var playing_audio = false;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED; #mousecaptured


func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if not GameMaster.man_active:
		# escape mouse_captured
		if Input.is_action_just_pressed("Cancel"):
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			start_jump.emit();
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward");
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
		if direction:
			velocity.x = direction.x * SPEED;
			velocity.z = direction.z * SPEED;
			if is_on_floor():
				start_run.emit();
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED);
			velocity.z = move_toward(velocity.z, 0, SPEED);
			if is_on_floor():
				start_idle.emit();
		if Input.is_action_just_pressed("Pause"): #pause mode
			toogle_mouse_mode(); #toogles mouse mode
			get_tree().paused = not get_tree().paused; #toogles paused of the menu
			$CameraArm/Camera3D/PauseMenu.visible = not $CameraArm/Camera3D/PauseMenu.visible; #toogles visibility of the menu

	move_and_slide()

#toogle mouse_mode
func toogle_mouse_mode():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

#mouse rotations:
func _input(event: InputEvent) -> void:
	if not GameMaster.man_active and event is InputEventMouseMotion: #if its active dog and mouse moves
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: #if mouse is captured
			rotate_y(deg_to_rad(-event.relative.x * mouse_h_sensitivity)); #rotates the horizontal axis
			$CameraArm.rotate_x(deg_to_rad(-event.relative.y * mouse_v_sensitivity)); #rotates the vertical axis
			$CameraArm.rotation.x = clamp($CameraArm.rotation.x,deg_to_rad(-30),deg_to_rad(0)); #clamps the rotation
