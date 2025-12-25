extends RigidBody3D
<<<<<<< HEAD

@export var SPEED: float = 12.0
@export var yaw_sensitivity: float = 8.0
@export var pitch_sensitivity: float = 80.0
@export var max_pitch: float = 80.0

const JUMP_FORCE: float = 7.0

@export var joystick_left: VirtualJoystick
@export var joystick_right: VirtualJoystick
@export var camera: Camera3D   # your Camera3D that's directly under CSGMesh3D

=======
@export var SPEED: float = 12.0
@export var yaw_sensitivity: float = 8.0
@export var pitch_sensitivity: float = 120.0
@export var max_pitch: float = 89.0
const JUMP_FORCE: float = 5.0
@export var joystick_left: VirtualJoystick
@export var joystick_right: VirtualJoystick
@onready var jumpBtn = $Node/Control/CanvasLayer/jumpbtn
@export var camera: Camera3D
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)
var input_dir: Vector2 = Vector2.ZERO
var yaw_input: float = 0.0
var pitch_input: float = 0.0
var is_grounded: bool = false

<<<<<<< HEAD

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
		
=======
# 🔥🔥 OPTIMIZATION COUNTERS 🔥🔥
var ground_check_counter: int = 0
var wall_check_counter: int = 0
const GROUND_CHECK_INTERVAL: int = 5  # only check every 5 frames
const WALL_CHECK_INTERVAL: int = 3    # only check every 3 frames
var cached_wall_result: bool = true
var cached_wall_normal: Vector3 = Vector3.ZERO

func _ready() -> void:
	axis_lock_angular_x = true
	axis_lock_angular_y = false
	axis_lock_angular_z = true
	
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.0
	physics_material_override.friction = 0.0

func _physics_process(delta: float) -> void:
	# only check ground every X frames instead of EVERY frame 💯
	ground_check_counter += 1
	if ground_check_counter >= GROUND_CHECK_INTERVAL:
		is_grounded = _check_ground()
		ground_check_counter = 0
	
	_capture_input()
	_apply_yaw(delta)
	_apply_pitch(delta)
	_handle_movement_NEW(delta)
	
	if is_grounded and Input.is_action_just_pressed("player_a_btn"):
		linear_velocity.y = JUMP_FORCE
		

func _capture_input() -> void:
	if joystick_left and joystick_left.is_pressed:
		input_dir = joystick_left.output
	else:
		input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_dovn")
	
	if joystick_right and joystick_right.is_pressed:
		yaw_input = -joystick_right.output.x
		pitch_input = -joystick_right.output.y
	else:
		yaw_input = -Input.get_action_strength("cam_right") + Input.get_action_strength("cam_left")
		pitch_input = -Input.get_action_strength("cam_down") + Input.get_action_strength("cam_up")
	
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)
	lock_rotation = false

func _apply_yaw(delta: float) -> void:
	if abs(yaw_input) > 0.1:
		var yaw_torque = Vector3.UP * yaw_input * yaw_sensitivity * 50.0
		apply_torque(yaw_torque * delta)
	else:
		angular_velocity.y *= 0.94

<<<<<<< HEAD

=======
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)
func _apply_pitch(delta: float) -> void:
	if camera and abs(pitch_input) > 0.05:
		var pitch_delta = pitch_input * pitch_sensitivity * delta
		camera.rotate_x(pitch_delta)
		
<<<<<<< HEAD
		# Clamp so you can't break your neck
=======
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)
		var current_pitch = rad_to_deg(camera.rotation.x)
		current_pitch = clamp(current_pitch, -max_pitch, max_pitch)
		camera.rotation.x = deg_to_rad(current_pitch)

<<<<<<< HEAD

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

=======
# 🔥🔥 OPTIMIZED MOVEMENT WITH CACHED WALL CHECKS 🔥🔥
func _handle_movement_NEW(_delta: float) -> void:
	var current_hvel = Vector3(linear_velocity.x, 0, linear_velocity.z)
	
	if input_dir.length() > 0.1:
		var move_dir = Vector3(input_dir.x, 0, input_dir.y)
		var world_dir = (global_transform.basis * move_dir).normalized()
		
		# only check walls every few frames instead of EVERY frame!! 💪
		wall_check_counter += 1
		if wall_check_counter >= WALL_CHECK_INTERVAL:
			cached_wall_result = _check_wall_in_direction(world_dir)
			if not cached_wall_result:
				cached_wall_normal = _get_wall_normal(world_dir)
			wall_check_counter = 0
		
		if cached_wall_result:
			# no wall = full send it 💨
			var target_vel = world_dir * SPEED * input_dir.length()
			var force = (target_vel - current_hvel) * mass * 35.0
			apply_central_force(force)
		else:
			# wall detected = slide along it ✋
			if cached_wall_normal != Vector3.ZERO:
				var slide_vel = current_hvel.slide(cached_wall_normal)
				var correction = (slide_vel - current_hvel) * mass * 50.0
				apply_central_force(correction)
			
			# kill forward velocity
			var dot_product = current_hvel.dot(world_dir)
			if dot_product > 0:
				apply_central_force(-world_dir * dot_product * mass * 40.0)
	else:
		# no input = brake 🛑
		apply_central_force(-current_hvel * mass * 20.0)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.transform.origin.y <= -90.0:
		var t = state.transform
		t.origin = Vector3(5.575, 6.042, 0.0)
		state.transform = t
	
		# stop the infinite fall loop
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO

func _check_wall_in_direction(direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var ray_distance = 0.6
	
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + direction * ray_distance
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	return result.size() == 0

func _get_wall_normal(direction: Vector3) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var ray_distance = 0.6
	
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + direction * ray_distance
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	if result.size() > 0 and result.has("normal"):
		return result.normal
	return Vector3.ZERO
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)

func _check_ground() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
<<<<<<< HEAD
		global_position + Vector3.DOWN * 0.7
=======
		global_position + Vector3.DOWN * 1.1
>>>>>>> edc8855 (Dij bestie zbbxv x z 🗣️🤠😱✈️😟😟😂🙁🙁🎉🥵🤬💀‼️🥀🖕🔥🖕🤬🥵🥵🥀🥀💚🦕😭🔥💚💚😭💚🤯🗣️🎉❤️‍🩹❤️‍🩹😱🙁🙁🤓❤️‍🩹😖💀❤️‍🩹‼️🤬💔🐢😭😢❤️‍🔥😈🥎🥎🥎😢❤️‍🔥✈️🦕😢😈🖕🦕🤠🖕🔥🤓🗣️😱🙁🥵😱😭🔥🔥💚🗣️‼️‼️😭❤️‍🩹🤬💔💔💔😖‼️🤬😖😖)
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result.size() > 0
