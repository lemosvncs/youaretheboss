extends Actor # Which extends KinematicBody2D

signal player_hp(hp)

export var stomp_impulse: = 100.0

var player_velocity:Vector2
var direction:Vector2
var is_jump_interrupted:bool=false

func _physics_process(delta: float) -> void:
	
	_gravity(delta)
	_set_direction()
	_calculate_move_velocity()
	_jump(delta)

	
	_velocity = move_and_slide(_velocity, Vector2.UP)
	player_velocity = _velocity	
	#print(_velocity.y)
	
func _gravity(delta):
	_velocity.y += gravity * delta
	
func _calculate_move_velocity() -> void:
	# Me diz se "speed" vai ser aplicado pro player ir pra esquerda ou pra direita
	_velocity.x = speed.x * direction.x

func _jump(delta):
	
	if direction.y == -1.0: #Jump == true
		_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		_velocity.y = 1.0

func _set_direction() -> void:
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		direction.y = -1.0
	else:
		direction.y = 1.0
	
func _stomp_velocity() -> void:
	_velocity = Vector2(_velocity.x, -stomp_impulse)

# SIGNALS:

func _on_EnemyDetector_body_entered(_body: Node) -> void:
	_stomp_velocity()

func _on_Enemy_boss_damage(sword_damage) -> void:
	hp -= sword_damage
	emit_signal("player_hp", hp)
	print("Player HP:", hp)

