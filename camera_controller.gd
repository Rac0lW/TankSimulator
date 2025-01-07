extends Node3D

@export var cam: Camera3D
@export var step: float = 0.2

@export var mouse_sens : float = 4.0
@onready var tank: Tank = $"../Tank"

func _input(event: InputEvent) -> void:
	if cam.current:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			cam.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			cam_range_limitation()
		return
		
		
	
	
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("roll_down"):
		increase_distance()

	if Input.is_action_just_pressed("roll_up"):
		close_distance()
		
	if cam.current != true:
		
		if Input.get_last_mouse_velocity().x < 0:
			tank.rotate_turret_left(delta)
		elif Input.get_last_mouse_velocity().x > 0:
			tank.rotate_turret_right(delta)
		else:
			pass
		
	#TODO: Cam switch
	
	position.x = tank.position.x
	position.z = tank.position.z
	
	turret_following(delta)
		

func increase_distance() -> void:
	cam.position.y += step
	cam.position.z += step
	range_limitation()

func close_distance() -> void:
	cam.position.y -= step
	cam.position.z -= step
	range_limitation()

func range_limitation() -> void:
	cam.position.y = clamp(3, 4, cam.position.y)
	cam.position.z = clamp(3, 4, cam.position.z)
	
func cam_range_limitation() -> void:
	cam.rotation.x = clamp(-30, 150, cam.rotation.x)

func turret_following(delta: float) -> void:
	if cam.current == false:
		return
	
	var tank_z = tank.current_turret_direction.normalized()
	var camera_z = global_transform.basis.z.normalized()
	#print("{}, {}", tank_z, camera_z)
	if tank_z != camera_z:
		if tank_z.cross(camera_z).y > 0.01:
			tank.rotate_turret_left(delta)
		elif tank_z.cross(camera_z).y < -0.01:
			tank.rotate_turret_right(delta)
		else:
			pass
