extends MeshInstance3D

@export var rotate_speed : float = 1.0

func rotate_left(delta: float) -> void:
	rotate_y(delta * rotate_speed)
	
func rotate_right(delta: float) -> void:
	rotate_y(delta * -rotate_speed)
