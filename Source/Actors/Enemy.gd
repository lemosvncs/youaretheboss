extends Actor

signal enemy_hp_update(enemy_hp)

var jump:bool = false
var can_jump = false
var this_player_position:Vector2 = Vector2.ZERO

func _ready() -> void:
	pass
	#_velocity.x = speed.x

func _physics_process(delta: float) -> void:
	if is_on_wall():
		_velocity.x *= -1.0
	
	_velocity.y += gravity * delta
	
	if jump && is_on_floor() && can_jump:
		_velocity.y = -speed.y
		can_jump = false
	
	go_to_player()
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y
	#_velocity = move_and_slide(_velocity, Vector2.UP)
	#print(_velocity.y)

func go_to_player():
	var plx: = this_player_position.x
	var enx: = position.x
	var delta_pos = plx - enx
	
	if delta_pos < -30 or delta_pos > 30:
	#print("delta pos: ", plx - enx)
	# Se está distante, se aproxima
		if plx > enx:
			_velocity.x = speed.x
		elif plx < enx:
			_velocity.x = -speed.x
			
	elif delta_pos < -15 or delta_pos > 15:
		# se está próximo, se distanceia
		if plx > enx:
			_velocity.x = -speed.x
		elif plx < enx:
			_velocity.x = speed.x
	else:
		_velocity.x = 0
		
	
func _on_AtompDetector_body_entered(_body: Node) -> void:
	hp -= 1
	emit_signal("enemy_hp_update", hp)
	#print(hp)
	#if body.global_position.y > get_node("StompDetector").global_position.y:
	#	return
	#get_node("EnemyCollision").disabled = true
	#queue_free()

	

	
	
func _on_FrontDetector_body_entered(body: Node) -> void:
	jump = true

func _on_BackDetector_body_entered(body: Node) -> void:
	jump = true
	
func _on_JumpDelay_timeout() -> void:
	can_jump = true
	#print(can_jump)

func _on_Player_player_position(player_position) -> void:
	this_player_position = player_position
