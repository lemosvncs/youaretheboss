extends StateMachine

func _state_logic(delta):
	add_state("walk")
	add_state("jumP")
	add_state("idle")
	add_state("attack")
	
	call_deferred("set_state", states.sleep)
