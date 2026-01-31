extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_h_sensitivity = 0.05;
var mouse_v_sensitivity = 0.05;
var agarrar_objeto = true; #variable para saber si puede tomar objetos
var objeto_al_alcance;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED; #mousecaptured

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if GameMaster.man_active:
		# escape mouse_captured
		if Input.is_action_just_pressed("Cancel") and not get_tree().paused:
			toogle_mouse_mode();
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
		if Input.is_action_just_pressed("Pause"): #pause mode
			toogle_mouse_mode(); #toogles mouse mode
			get_tree().paused = not get_tree().paused; #toogles paused of the menu
			$CameraArm/Camera3D/UI/PauseMenu.visible = not $CameraArm/Camera3D/UI/PauseMenu.visible; #toogles visibility of the menu
		if Input.is_action_just_pressed("Torch"):
			toogle_torch();
		if objeto_al_alcance: #si hay un objeto al alcance
			if Input.is_action_just_pressed("Take"): #y presionan la tecla de tomar
				if agarrar_objeto: #si se puede agarrar objeto
					objeto_al_alcance.libre = false; #desactiva esta propiedad del objeto
					agarrar_objeto = false; #desactiva el agarre
					if objeto_al_alcance.get_parent(): #removemos el objeto del escenario
						objeto_al_alcance.get_parent().remove_child(objeto_al_alcance);
					self.add_child(objeto_al_alcance); # y lo agregamos a man
					objeto_al_alcance.position = Vector3(-1.2,2,-1.2); #finalmente lo posicionamos
				else:# en caso de soltar
					print("Objeto soltado");
					agarrar_objeto = true; #permite volver a agarrar
					objeto_al_alcance.libre = true; #libera al objeto
					var posicion_global_objeto = objeto_al_alcance.get_global_position(); #guarda la posición global
					self.remove_child(objeto_al_alcance); #remueve del hombre
					self.get_parent().add_child(objeto_al_alcance); #lo añade a la escena
					objeto_al_alcance.position = posicion_global_objeto; #recoloca la misma posición
					objeto_al_alcance = null; #vacía el objeto
					
		sostener_objeto(); #en todo momento sostiene el objeto
					

	move_and_slide()

# grab_object
func sostener_objeto():
	pass

#toogle torch status
func toogle_torch():
	$Torch/OmniLight3D.visible = not $Torch/OmniLight3D.visible;

#toogle mouse_mode
func toogle_mouse_mode():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

#mouse rotations:
func _input(event: InputEvent) -> void:
	if GameMaster.man_active and event is InputEventMouseMotion:# if its active and mouse moves
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: #if the mouse is captured
			rotate_y(deg_to_rad(-event.relative.x * mouse_h_sensitivity)); #rotates the horizontal axis
			$CameraArm.rotate_x(deg_to_rad(-event.relative.y * mouse_v_sensitivity)); #rotates the vertical axis
			$CameraArm.rotation.x = clamp($CameraArm.rotation.x,deg_to_rad(-20),deg_to_rad(40)); #clamps the rotation

#cuando entra al area

func _on_area_3d_body_entered(body: Node3D) -> void: #object getting into man's reach
	if "PuzzlePiece" in body.get_name(): #checks if it's not the man as self, the floor or the dog
		var name = body.get_name().replace("PuzzlePiece","");
		$CameraArm/Camera3D/UI/Labels/ObjectInfo.visible = true; #visibles the respective label
		$CameraArm/Camera3D/UI/Labels/ObjectInfo.text = "Pieza de rompecabezas ("+name+") recogida"; #and prints this message
		body.dissapear(); #dissapears the piece
		await get_tree().create_timer(0.6).timeout;
		$CameraArm/Camera3D/UI/Labels/ObjectInfo.visible = false;
	elif "Estatua" in body.get_name(): #Cuando la estatua entra y está en el piso
		if agarrar_objeto and not objeto_al_alcance: #si puede agarrar objetos
			$CameraArm/Camera3D/UI/Labels/ActionInfo.visible = true; #muesrta la etiqueta
			$CameraArm/Camera3D/UI/Labels/ActionInfo.text = "Tomar estatua"; #imprime esto como acción
			objeto_al_alcance = body; #guarda el objeto

#cuando sale del area de alcance

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Estatua" in body.get_name(): #cuando sale la estatua
		$CameraArm/Camera3D/UI/Labels/ActionInfo.visible = false; #vueve invisible la etiqueta
		if agarrar_objeto:
			objeto_al_alcance = null; #vacia el objeto al alcance
