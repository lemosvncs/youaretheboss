extends Actor

signal enemy_hp_update(enemy_hp)

func _ready() -> void:
	_velocity.x = speed.x
	
func _on_AtompDetector_body_entered(_body: Node) -> void:
	hp -= 1
	emit_signal("enemy_hp_update", hp)
	#print(hp)
	#if body.global_position.y > get_node("StompDetector").global_position.y:
	#	return
	#get_node("EnemyCollision").disabled = true
	#queue_free()

	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y
