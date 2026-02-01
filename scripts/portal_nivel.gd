extends Node3D

@export var nombre_escena : String

func _on_trigger_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if (body.is_in_group("Players")):
		GameMaster.goto_scene("res://Scenes/" + str(nombre_escena))
