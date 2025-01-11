extends CharacterBody3D
class_name Tank

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var speed: float
@export var rotate_speed: float = 5.0

@onready var tank_head: MeshInstance3D = $TankHead
@onready var tank_cam: Camera3D = $TankHead/Camera3D
@onready var camera_3d: Camera3D = $"../Pivot/Camera3D"



var current_turret_direction: Vector3

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Aiming") and camera_3d.current == true:
		tank_cam.make_current()
		print("Camera Switching")
		
	
	if event.is_action_released("Aiming") and camera_3d.current == false:
		camera_3d.make_current()
		

func _ready() -> void:
	current_turret_direction = -tank_head.global_transform.basis.z
	
func _physics_process(delta: float) -> void:
	
	current_turret_direction = -tank_head.global_transform.basis.z
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("Left"):
		rotate_left(delta)
		
	if Input.is_action_pressed("Right"):
		rotate_right(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()
	
func rotate_left(delta: float) -> void:
	rotate_y(delta * rotate_speed)

func rotate_right(delta: float) -> void:
	rotate_y(-delta * rotate_speed)
	
func rotate_turret_left(delta: float) -> void:
	tank_head.rotate_left(delta)
	
func rotate_turret_right(delta: float) -> void:
	tank_head.rotate_right(delta)
	
