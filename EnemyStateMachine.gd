extends "res://StateMachine.gd"

func _ready() -> void:
	add_state("run")
	add_state("jump")
	add_state("idle")
	add_state("attack")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent._apply_gravity(delta)
	parent._apply_movement()
	
	parent.define_player_position()
	parent.jump_tiles()
	parent.go_to_player()
	#parent.animation_manager()
	parent.sword_attack()
	
func _set_state(delta):
	pass
	
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
		states.attack:
			if !parent.atacking:
				return states.idle
	return null
	
func _enter_state(new_state, old_state):
		match new_state:
			states.idle:
				parent.enemySprite.play("idle")
			states.run:
				parent.enemySprite.play("moving")
			states.jump:
				parent.enemySprite.play("moving")
			states.fall:
				parent.enemySprite.play("idle")
	
func _exit_state(old_state, new_state):
	pass
