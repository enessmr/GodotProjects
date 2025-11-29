extends RigidBody3D

@export var SPEED: float = 12.0
@export var yaw_sensitivity: float = 8.0
@export var pitch_sensitivity: float = 80.0
@export var max_pitch: float = 80.0

const JUMP_FORCE: float = 7.0

@export var joystick_left: VirtualJoystick
@export var joystick_right: VirtualJoystick
@export var camera: Camera3D   # your Camera3D that's directly under CSGMesh3D

var input_dir: Vector2 = Vector2.ZERO
var yaw_input: float = 0.0
var pitch_input: float = 0.0
var is_grounded: bool = false


func _ready() -> void:
	# Lock X and Z rotation so looking up/down can't flip physics
	lock_rotation = true
	
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.0
	physics_material_override.friction = 1.0
	
	# Make sure CSGMesh3D and Camera follow physics perfectly
	# (they already do by default if they're children)


func _physics_process(delta: float) -> void:
	is_grounded = _check_ground()
	_capture_input()
	
	# Only yaw the entire RigidBody (and therefore the CSGMesh3D + cam)
	_apply_yaw(delta)
	
	# Pitch ONLY the camera (never touches physics)
	_apply_pitch(delta)
	
	_handle_movement(delta)
	
	if is_grounded and Input.is_action_just_pressed("ui_accept"):
		apply_central_impulse(Vector3.UP * JUMP_FORCE)


func _capture_input() -> void:
	# Movement - left stick
	if joystick_left and joystick_left.is_pressed:
		input_dir = joystick_left.output
	else:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Look - right stick
	if joystick_right and joystick_right.is_pressed:
		yaw_input = -joystick_right.output.x
		pitch_input = -joystick_right.output.y
		lock_rotation = false
	else:
		yaw_input = -Input.get_action_strength("cam_right") + Input.get_action_strength("cam_left")
		pitch_input = -Input.get_action_strength("cam_down") + Input.get_action_strength("cam_up")
		lock_rotation = false
		
	lock_rotation = false

func _apply_yaw(delta: float) -> void:
	if abs(yaw_input) > 0.1:
		var yaw_torque = Vector3.UP * yaw_input * yaw_sensitivity * 50.0
		apply_torque(yaw_torque * delta)
	else:
		angular_velocity.y *= 0.94


func _apply_pitch(delta: float) -> void:
	if camera and abs(pitch_input) > 0.05:
		var pitch_delta = pitch_input * pitch_sensitivity * delta
		camera.rotate_x(pitch_delta)
		
		# Clamp so you can't break your neck
		var current_pitch = rad_to_deg(camera.rotation.x)
		current_pitch = clamp(current_pitch, -max_pitch, max_pitch)
		camera.rotation.x = deg_to_rad(current_pitch)


func _handle_movement(delta: float) -> void:
	if input_dir.length() > 0.1:
		# Direction based on where the player is facing (Y rotation only!)
		var move_dir = Vector3(input_dir.x, 0, input_dir.y)
		var world_dir = (global_transform.basis * move_dir).normalized()
		
		var target_vel = world_dir * SPEED * input_dir.length()
		var current_hvel = Vector3(linear_velocity.x, 0, linear_velocity.z)
		var force = (target_vel - current_hvel) * mass * 30.0
		
		apply_central_force(force)
	else:
		var hvel = Vector3(linear_velocity.x, 0, linear_velocity.z)
		apply_central_force(-hvel * mass * 18.0)


func _check_ground() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + Vector3.DOWN * 0.7
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result.size() > 0
