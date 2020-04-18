extends ProgressBar

func _on_MainScene_main_signal_enemy_hp(enemy_hp) -> void:
	print(enemy_hp)
	value = enemy_hp
