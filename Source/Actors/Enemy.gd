extends Actor

signal enemy_hp_update(enemy_hp)

export var distance_to_follow_player:int = 100

var jump:bool = false
var can_jump = false
var this_player_position:Vector2 = Vector2.ZERO

var an_jumping:bool = false

func _ready() -> void:
	pass
	#_velocity.x = speed.x

func _physics_process(delta: float) -> void:
	
	jump()
	go_to_player()
	animation_manager()
	
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	print(_velocity)
	
func animation_manager():
	# Moving if moving:
	if _velocity.x > 100: 
		$EnemySprite.play("moving")
		$EnemySprite.flip_h = false
	elif _velocity.x < -100:
		$EnemySprite.play("moving")
		$EnemySprite.flip_h = true
	else:
		$EnemySprite.play("idle")
		$EnemySprite.flip_h = false
	
func jump():
	if can_jump:
		print(can_jump)
		if jump == true && is_on_floor() == true:
			_velocity.y = -speed.y
			can_jump = false
			jump = false
	

func go_to_player():
	var plx: = this_player_position.x
	var enx: = position.x
	var delta_pos = plx - enx
	
	if delta_pos < -100 or delta_pos > 100:
	#print("delta pos: ", plx - enx)
	# Se está distante, se aproxima
		if plx > enx:
			_velocity.x += speed.x
		elif plx < enx:
			_velocity.x -= speed.x
	
	
	elif delta_pos > -(95) or delta_pos < (95):
		# se está próximo, se distanceia
		if plx > enx:
			_velocity.x -= speed.x
		elif plx < enx:
			_velocity.x += speed.x
	else:
		_velocity.x = 0
	print(delta_pos)
		
	
func _on_AtompDetector_body_entered(_body: Node) -> void:
	hp -= 1
	emit_signal("enemy_hp_update", hp)
	#print(hp)
	#if body.global_position.y > get_node("StompDetector").global_position.y:
	#	return
	#get_node("EnemyCollision").disabled = true
	#queue_free()

	

	
	
func _on_FrontDetector_body_entered(body: Node) -> void:
	if body.is_in_group("Tiles"):
		print(body.name, can_jump)
		jump = true

func _on_BackDetector_body_entered(body: Node) -> void:
	if body.is_in_group("Tiles"):
		print(body.name, can_jump)
		jump = true
	
func _on_JumpDelay_timeout() -> void:
	can_jump = true
	#print(can_jump)

func _on_Player_player_position(player_position) -> void:
	this_player_position = player_position
