extends AnimationTree

var playback: AnimationNodeStateMachinePlayback
#var current_state
var previous_state
onready var parent = get_parent()

func _ready():
	playback = get("parameters/playback") # State Machine
	playback.start("idle")
	#current_state = playback.get_current_node()
	active = true
	#_get_transition()

func _physics_process(delta: float) -> void:
	_state_logic(delta)	

func _state_logic(delta):
	_get_transition()
	_set_direction()

	parent._gravity(delta)
	_set_direction()
	parent._apply_movement()
	parent._jump(delta)

func _set_direction() -> void:
	parent.direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if playback.get_current_node() == "idle" || playback.get_current_node() == "run":
		if Input.is_action_just_pressed("jump"):
			parent.direction.y = -1.0
		else:
			parent.direction.y = 1.0

	if playback.get_current_node() == "jump":
		if Input.is_action_just_released("jump"):
			parent.is_jump_interrupted	= true

func _get_transition():
	match playback.get_current_node():
		"idle":
			if !parent.is_on_floor():
				if parent._velocity.y < 0:
					playback.travel("jump")
				elif parent._velocity.y > 0:
					playback.travel("fall")
			elif parent._velocity.x != 0:
				playback.travel("run")
		"run":
			if !parent.is_on_floor():
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
