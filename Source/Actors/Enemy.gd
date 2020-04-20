extends Actor

signal enemy_hp_update(enemy_hp)
signal boss_damage(sword_damage)

export var distance_to_follow_player:int = 50
export var fugir_modifier:float = 1.3
export var sword_damage:int = 1

var can_attack:bool = false
var attack:bool = false
var sword_hit:bool = false # True if detected collision with player
var moving_right:bool
var jump:bool = false
var can_jump:bool = false
var this_player_position:Vector2 = Vector2.ZERO

var an_jumping:bool = false

onready var player = get_tree().get_nodes_in_group("Player")



func _ready() -> void:
	print(player[0])
	#get_groups("Player")
	#_velocity.x = speed.x

func _physics_process(delta: float) -> void:
	
	jump_tiles()
	go_to_player()
	animation_manager()
	sword_attack()
	
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	if _velocity.x > 1:
		moving_right = true
	else:
		moving_right = false
	#print(moving_right)
	
func animation_manager():
	# Moving if moving:
	if moving_right: 
		$EnemySprite.play("moving")
		$EnemySprite.flip_h = false
	elif !moving_right:
		$EnemySprite.play("moving")
		$EnemySprite.flip_h = true
	else:
		$EnemySprite.play("idle")
		$EnemySprite.flip_h = false
		
	# Attack:
	if attack:
		if moving_right:
			$WeaponSprite/AnimationPlayer.play("swordAttack")
		elif !moving_right:
			$WeaponSprite/AnimationPlayer.play("swordAttack_flip_h")
	elif moving_right:
		$WeaponSprite/AnimationPlayer.play("weaponIdle")
	elif !moving_right:
		$WeaponSprite/AnimationPlayer.play("weaponIdle_flip_h")
		
func sword_attack():
	if attack and can_attack:
		$WeaponSprite/WeaponArea.monitorable = true
		#print("atacking")
		
	else:
		$WeaponSprite/WeaponArea.monitorable = false
		#print("NOT attacking")
	
	if sword_hit:
		emit_signal("boss_damage", sword_damage)
		sword_hit = false
			
func jump_tiles():
	if can_jump:
		#print(can_jump)
		if jump == true && is_on_floor() == true:
			_velocity.y = -speed.y
			can_jump = false
			jump = false
	

func go_to_player():
	var plx: = this_player_position.x
	var enx: = position.x
	var delta_pos = plx - enx
	
	if delta_pos < -distance_to_follow_player or delta_pos > distance_to_follow_player:
	#print("delta pos: ", plx - enx)
	# Se está distante, se aproxima
		attack = false
		if plx > enx:
			_velocity.x += speed.x
		elif plx < enx:
			_velocity.x -= speed.x
	
	
	elif delta_pos > -(distance_to_follow_player) or delta_pos < (distance_to_follow_player):
		attack = true
		
		
		# se está próximo, se distanceia
		if plx > enx:
			_velocity.x -= speed.x*fugir_modifier
		elif plx < enx:
			_velocity.x += speed.x*fugir_modifier
	else:
		attack = false
		_velocity.x = 0
	#print(delta_pos)
		
	
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
		#print(body.name, can_jump)
		jump = true

func _on_BackDetector_body_entered(body: Node) -> void:
	if body.is_in_group("Tiles"):
		#print(body.name, can_jump)
		jump = true
	
func _on_JumpDelay_timeout() -> void:
	can_jump = true
	#print(can_jump)

func _on_Player_player_position(player_position) -> void:
	this_player_position = player_position


func _on_WeaponArea_body_entered(body: Node) -> void:
	if body.name == "Player":
		sword_hit = true

func _on_AttackDelay_timeout() -> void:
	can_attack = true
