extends Node2D

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
