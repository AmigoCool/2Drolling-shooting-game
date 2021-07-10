extends Control


func _ready():
	pass
	
func _on_restart_pressed():
	get_tree().change_scene("res://src/stage.tscn")

func _on_exitgame_pressed():
	get_tree().quit()
