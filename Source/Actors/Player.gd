extends Actor # Which extends KinematicBody2D

signal player_hp(hp)

export var stomp_impulse: = 100.0

var player_velocity:Vector2
var direction:Vector2
var is_jump_interrupted:bool=false
var stomp=false
onready var playerSprite = $PlayerSprite

func _physics_process(_delta: float) -> void:
	pass

	
func _gravity(delta):
	_velocity.y += gravity * delta
	
func _apply_movement() -> void:
	_velocity = move_and_slide(_velocity, Vector2.UP)
	player_velocity = _velocity
	_velocity.x = speed.x * direction.x

func _jump(delta):
	
	if direction.y == -1.0: #Jump == true
		_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		is_jump_interrupted = false
		_velocity.y = 1.0

func _stomp_velocity() -> void:
	_velocity = Vector2(_velocity.x, -stomp_impulse)
	stomp = false

# SIGNALS:

func _on_EnemyDetector_body_entered(_body: Node) -> void:
	stomp = true
	_stomp_velocity()

func _on_Enemy_boss_damage(sword_damage) -> void:
	hp -= sword_damage
	emit_signal("player_hp", hp)
	print("Player HP:", hp)

