extends "res://StateMachine.gd"

func _ready() -> void:
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	#add_state("stomp")
	#add_state("attack")
	call_deferred("set_state", states.idle)

func _set_direction() -> void:
	
	parent.direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if state == states.idle or state == states.run:
		if Input.is_action_just_pressed("jump"):
			parent.direction.y = -1.0
		else:
			parent.direction.y = 1.0
			
		if Input.is_action_just_released("jump"):
			parent.is_jump_interrupted	= true
	
func _state_logic(delta):
	parent._gravity(delta)
	_set_direction()
	parent._apply_movement()
	parent._jump(delta)

# warning-ignore:unused_argument
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent._velocity.y < 0:
					return states.jump
				elif parent._velocity.y > 0:
					return states.fall
			elif parent._velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent._velocity.y < 0:
					return states.jump
				elif parent._velocity.y > 0:
					return states.fall
			elif parent._velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent._velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent._velocity.y < 0:
				return states.jump
	return null
# warning-ignore:unused_argument
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.playerSprite.play("idle")
		states.run:
			parent.playerSprite.play("moving")
		states.jump:
			parent.playerSprite.play("moving")
		states.fall:
			parent.playerSprite.play("idle")

# warning-ignore:unused_argument
func _exit_state(old_state, new_state):
	pass
