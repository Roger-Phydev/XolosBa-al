extends Node3D

var is_completed = false;

func _process(delta: float) -> void:
	if is_completed and position.y > -3: #si está más alto que -3
		position.y -= 0.05; #le va restando

func _on_balanza_is_balanced() -> void:
	is_completed = true;
	
