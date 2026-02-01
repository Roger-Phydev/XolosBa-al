extends Node3D

var check_red = false; #las tres condiciones de resolución del rompecabezas
var check_blue = false;
var check_green = false;
var win = false;
var audio_hombre = false; #inicializa en falso el que escuchen el perro y el hombre
var audio_perro = false;
var track_hombre; #música que escucha el hombre
var track_perro; #música que escucha el perro

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var letrero = $Man.find_child("ObjectInfo");
	$Nivel.play(); #sonido de fondo
	letrero.visible = true;
	letrero.text = """Escucha con atención las señales
	los muertos a veces son más difíciles de escuchar para el hombre
	sabrás contar las veces que aparece frente a ti un dilema?""";
	await get_tree().create_timer(10).timeout;
	letrero.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toogle"):
		toogle_active_char();
	if not win: #si no se ha ganado sigue checano
		win = check_red and check_blue and check_green; #es la combinación de las tres condiciones
	else:
		entregar_medallon(); #en caso de ganar, entrega el medallón
	if GameMaster.man_active and audio_hombre and $Man.playing_audio:
		track_hombre.play();
		$Nivel.stop(); #detiene la música del nivel
		$Man.playing_audio = false;
	if not GameMaster.man_active and audio_perro and $Dog.playing_audio:
		$Dog.playing_audio = false;
		$Nivel.stop(); #detiene la música del nivel
		track_perro.play();

#entregar medallón
func entregar_medallon():
	if $Premio.position.y > -3: #si está más alto que -3
		$Premio.position.y -= 0.05; #le va restando

#entra al area de sonido general
func _on_area_sonido_body_entered(body: Node3D) -> void:
	#activa el audio respectivo según cada uno
	if "Man" in body.get_name():
		audio_hombre = true;
		body.playing_audio = true;
		track_hombre = $PistaRoja;
	elif "Dog" in body.get_name():
		audio_perro = true;
		body.playing_audio = true;
		track_perro = $PistaRoja;

#
func _on_area_sonido_body_exited(body: Node3D) -> void:
	if "Man" in body.get_name():
		audio_hombre = false;
		body.playing_audio = false;
		track_hombre.stop(); #pausa sonido
	elif "Dog" in body.get_name():
		audio_perro = false;
		body.playing_audio = false;
		track_perro.stop(); #pausa sonido
	$Nivel.play(); #pone la música de fondo

func _on_area_sonido_perro_body_entered(body: Node3D) -> void:
	#activa el audio solo en el perro
	if "Dog" in body.get_name():
		audio_perro = true;
		body.playing_audio = true;
		track_perro = $PistaAzul;


func _on_area_sonido_perro_body_exited(body: Node3D) -> void:
	if "Dog" in body.get_name():
		audio_perro = false;
		body.playing_audio = false;
		track_perro.stop();
	$Nivel.play(); #pone la música de fondo
	
func toogle_active_char():
	GameMaster.man_active = not GameMaster.man_active; #toogles state of this variable
	# then changes the state of active camera whether man is active or not
	if track_hombre:
		track_hombre.stop();
	if track_perro:
		track_perro.stop();
	$Man.playing_audio = audio_hombre;
	$Dog.playing_audio = audio_perro;
	if GameMaster.man_active:
		var cameraMan = $Man.get_child(2).get_child(0)
		cameraMan.current = true;
		var cameraDog = $Dog.get_child(2).get_child(0);
		var greyscaleLayer : CanvasLayer = cameraDog.get_node_or_null("CanvasLayer");
		if (greyscaleLayer):
			greyscaleLayer.hide();
	else:
		var camera = $Dog.get_child(2).get_child(0)
		camera.current = true;
		var greyscaleLayer : CanvasLayer = camera.get_node_or_null("CanvasLayer");
		if (greyscaleLayer):
			greyscaleLayer.show();

#manejo de las canastas
#Roja:
#	Entra
func _on_rojo_body_entered(body: Node3D) -> void:
	if "Rojo" in body.get_name(): #si entra la pieza roja
		check_red = true; #cambia a true este check
#	Sale
func _on_rojo_body_exited(body: Node3D) -> void:
	if "Rojo" in body.get_name(): #si sale la pieza roja
		check_red = false; #cambia a false este check

#Verde:
#	Entra:
func _on_verde_body_entered(body: Node3D) -> void:
	if "Verde" in body.get_name(): #si entra la pieza verde
		check_green = true; #cambia a true este check
#	Sale:
func _on_verde_body_exited(body: Node3D) -> void:
	if "Verde" in body.get_name(): #si entra la pieza verde
		check_green = false; #cambia a false este check

#Azul:
#	Entra:
func _on_azul_body_entered(body: Node3D) -> void:
	if "Azul" in body.get_name(): #si entra la pieza azul
		check_blue = true; #cambia a true este check
#	Sale:
func _on_azul_body_exited(body: Node3D) -> void:
	if "Azul" in body.get_name(): #si entra la pieza azul
		check_blue = false; #cambia a false este check
