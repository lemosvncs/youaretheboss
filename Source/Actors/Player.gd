extends Actor # Which extends KinematicBody2D
export var stomp_impulse: = 100.0
# var direction : Vector2 = Vector2.ZERO

#func _on_EnemyDetector_area_entered(area: Area2D) -> void:
#	print("detected")
#	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	
func _on_EnemyDetector_body_entered(_body: Node) -> void:
	print(_velocity.y)
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	print(_velocity.y)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - 
		Input.get_action_strength("ui_left"),
		- 1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
		
func calculate_move_velocity(
		linear_velocity : Vector2,
		direction : Vector2,
		speed : Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var output: = linear_velocity
	output.x = speed.x * direction.x
	# _velocity.y += gravity * delta
	output.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		output.y = speed.y * direction.y
	if is_jump_interrupted:
		output.y = 0.0
	return output
	
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = Vector2()
	#out.x = linear_velocity.x
	#out.y = -impulse
	out = Vector2(linear_velocity.x, -impulse)
	#print(out, " I: ", impulse)
	return out

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction:= get_direction()
	#_velocity = speed * direction
	#_velocity.y = max(_velocity.y, speed.y)
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, Vector2.UP)





