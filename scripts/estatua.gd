extends CharacterBody3D

var libre = true;# indica si el objeto está libre, osea, no agarrado
@export var color : Color = Color.WHITE;

func _ready() -> void:
	var material = StandardMaterial3D.new();
	material.albedo_color = color;
	$model/Cabeza.set_surface_override_material(0,material);

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and libre: #si no toca el piso y está libre cae
		velocity += get_gravity() * delta
	move_and_slide()
