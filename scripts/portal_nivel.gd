extends Node3D

@export var destino : PackedScene

func _on_trigger_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if (body.is_in_group("Players")):
		GameMaster.goto_scene(destino.resource_path)
