extends Node3D

@export var puntaBrazo : Node3D

signal agregar_peso(peso : float)
signal quitar_peso(peso : float)

func _on_trigger_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if (body.has_node("ObjetoConPeso")):
		var objeto_con_peso : ObjetoConPeso = body.get_node("ObjetoConPeso")
		print({"peso +": objeto_con_peso.peso})
		agregar_peso.emit(objeto_con_peso.peso)

func _on_trigger_body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if (body.has_node("ObjetoConPeso")):
		var objeto_con_peso : ObjetoConPeso = body.get_node("ObjetoConPeso")
		print({"peso -": objeto_con_peso.peso})
		quitar_peso.emit(objeto_con_peso.peso)
