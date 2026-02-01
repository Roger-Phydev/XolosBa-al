extends Node3D

var animationPlayer : AnimationPlayer

func _ready() -> void:
	animationPlayer = $AnimationPlayer

func _on_dog_start_idle() -> void:
	animationPlayer.play("Armature|IdleXolo")


func _on_dog_start_jump() -> void:
	animationPlayer.play("Armature|XoloJumping")


func _on_dog_start_run() -> void:
	animationPlayer.play("Armature|XoloRunning")
