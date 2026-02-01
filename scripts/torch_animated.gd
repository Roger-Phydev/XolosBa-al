extends Node3D

var animationPlayer : AnimationPlayer
var idle_position : Vector3
var run_position : Vector3

func _ready() -> void:
	animationPlayer = $AnimationPlayer
	idle_position = $PosicionAntorchaIdle.position
	run_position = $PosicionAntorchaRun.position

func _on_man_start_human_idle() -> void:
	if (animationPlayer):
		animationPlayer.play("Cylinder|IdleTorch")
	position = Vector3(0,0,0)


func _on_man_start_human_run() -> void:
	if (animationPlayer):
		animationPlayer.play("Cylinder|RunTorch")
	position = run_position - idle_position
	
