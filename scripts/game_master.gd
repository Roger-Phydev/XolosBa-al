extends Node

var man_active = true; #indicates if the man is active

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("gamemaster cargado");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#toogle active:
func toogle_char():
	man_active = not man_active;
