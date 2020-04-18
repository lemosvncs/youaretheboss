extends Node2D

onready var enemy_hp_main:int

signal main_signal_enemy_hp(enemy_hp)

func _on_Enemy_enemy_hp_update(enemy_hp) -> void:
	enemy_hp_main = enemy_hp
	emit_signal("main_signal_enemy_hp", enemy_hp_main)
