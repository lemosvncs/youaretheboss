extends KinematicBody2D
class_name Actor

#signal killed()

export var speed : Vector2 = Vector2(300.0, 1000.0)
export var gravity : float = 3000.0
export var max_hp : int = 100

onready var hp = max_hp
var _velocity : Vector2 = Vector2.ZERO
