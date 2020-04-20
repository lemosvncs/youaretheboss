extends ProgressBar

func _on_MainScene_main_signal_enemy_hp(enemy_hp) -> void:
	#print(enemy_hp)
	value = enemy_hp


func _on_MainScene_main_singal_player_hp(hp) -> void:
	value = hp
