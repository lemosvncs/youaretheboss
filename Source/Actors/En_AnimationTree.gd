extends AnimationTree

var playback: AnimationNodeStateMachinePlayback
#var current_state
var previous_state
var current_hp
var previous_hp
var hit:bool = false

onready var parent = get_parent()

func _ready():
	playback = get("parameters/playback") # State Machine
	playback.start("idle")
	#current_state = playback.get_current_node()
	active = true
	#_get_transition()

func _physics_process(delta: float) -> void:
	parent._apply_gravity(delta)
	parent._apply_movement()


	parent.jump_tiles()
	parent.go_to_player()
	#parent.animation_manager()
	parent.sword_attack()
	_state_logic(delta)	

func _state_logic(delta):
	_get_transition()
	hp_tracker()

#	parent._gravity(delta)
#	_set_direction()
#	parent._apply_movement()
#	parent._jump(delta)

func _get_transition():
	print(playback.get_current_node())
	match playback.get_current_node():
		"hit":
			if !hit:
				playback.travel("idle")
		"idle":
			if hit:
				playback.travel("hit")
			elif !parent.is_on_floor():
				if parent._velocity.y < 0:
					playback.travel("jump")
				elif parent._velocity.y > 0:
					playback.travel("fall")
			elif parent._velocity.x != 0:
				playback.travel("run")
		"run":
			if hit:
				playback.travel("hit")
			elif !parent.is_on_floor():
				if parent._velocity.y < 0:
					playback.travel("jump")
				elif parent._velocity.y > 0:
					playback.travel("fall")
			elif parent._velocity.x == 0:
				playback.travel("idle")
		"jump":
			if parent.is_on_floor():
				playback.travel("idle")
			elif parent._velocity.y >= 0:
				playback.travel("fall")
		"fall":
			if parent.is_on_floor():
				playback.travel("idle")
			elif parent._velocity.y < 0:
				playback.travel("jump")
	return null

func hp_tracker():
	if previous_hp != current_hp:
		hit = true
		previous_hp = current_hp
	elif previous_hp == current_hp:
		hit = false
	#print("PHP: ", previous_hp)
	#print("CHP: ", current_hp)
	print(hit)

func _on_Enemy_enemy_hp_update(enemy_hp) -> void:
	current_hp = enemy_hp
	
