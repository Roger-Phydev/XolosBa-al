extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toogle"):
		toogle_active_char();

func toogle_active_char():
	GameMaster.man_active = not GameMaster.man_active; #toogles state of this variable
	# then changes the state of active camera whether man is active or not
	if GameMaster.man_active:
		$Man.get_child(2).get_child(0).current = true;
	else:
		$Dog.get_child(2).get_child(0).current = true;
