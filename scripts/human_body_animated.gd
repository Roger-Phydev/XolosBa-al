extends Node3D

var animationPlayer : AnimationPlayer

func _ready() -> void:
	animationPlayer = $AnimationPlayer

func _on_man_start_human_idle() -> void:
	animationPlayer.play("Armature|IdleBody")


func _on_man_start_human_run() -> void:
	animationPlayer.play("Armature|RunBody")
	
