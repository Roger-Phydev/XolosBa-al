extends Node3D

signal is_balanced;

@export var peso_izquierda := 0.0;
@export var peso_derecha := 0.0;
@export var limites_angulos_deg := 10;
@export var rotational_speed := 10;
var is_balanced_done = false;
enum BALANCE_STATE { LEFT, RIGHT, MIDDLE }
var balance_state : BALANCE_STATE;
var brazos : Node3D;

func _ready():
	brazos = get_node("ModelosDinamicos/Brazos")

func _process(_delta: float) -> void:
	check_imbalance()
	tilt()

func _on_plataforma_balanza_izquierda_agregar_peso(peso: float) -> void:
	peso_izquierda += peso
	this_print();


func _on_plataforma_balanza_derecha_agregar_peso(peso: float) -> void:
	peso_derecha += peso
	this_print();


func _on_plataforma_balanza_derecha_quitar_peso(peso: float) -> void:
	peso_derecha -= peso
	this_print();


func _on_plataforma_balanza_izquierda_quitar_peso(peso: float) -> void:
	peso_izquierda -= peso
	this_print();
	
func check_imbalance():
	if (abs(peso_izquierda - peso_derecha) < 0.1):
		balance_state = BALANCE_STATE.MIDDLE
	elif (peso_izquierda - peso_derecha > 0.1):
		balance_state = BALANCE_STATE.LEFT
	elif (peso_derecha - peso_izquierda > 0.1):
		balance_state = BALANCE_STATE.RIGHT
		
func tilt():
	# Checar rotacion actual
	var rotacion_actual = brazos.rotation_degrees.z;
	# Checar rotacion objetivo
	var rotacion_objetivo : float;
	match balance_state:
		BALANCE_STATE.LEFT:
			rotacion_objetivo = -limites_angulos_deg;
		BALANCE_STATE.RIGHT:
			rotacion_objetivo = limites_angulos_deg;
		BALANCE_STATE.MIDDLE:
			rotacion_objetivo = 0;
	if (abs(rotacion_actual - rotacion_objetivo) < 0.1):
		if (balance_state == BALANCE_STATE.MIDDLE):
			exito();
		return;
		
	fallo()
	# Direccion deseada
	var direccion : float = sign(rotacion_objetivo - rotacion_actual);
	# Agregar velocidad de rotacion
	var nueva_rotacion = rotacion_actual + direccion * rotational_speed * get_process_delta_time();
	# Rotar
	brazos.rotation_degrees.z = nueva_rotacion;
	
func exito():
	is_balanced_done = true;
	$LuzExito.visible = true;
	is_balanced.emit()
	
func fallo():
	is_balanced_done = false;
	$LuzExito.visible = false;

func this_print():
	print({
		"peso_derecha": peso_derecha,
		"peso_izquierda": peso_izquierda,
		"balance_state": balance_state,
	})
