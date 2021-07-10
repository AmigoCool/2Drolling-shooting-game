extends Control

var enemykill = 0
var time_format = 0
var time_bonus = 0
var score = 0

func _ready():
	var time_min = floor(Global.time/60)
	var time_min_format = "0" + str(time_min) if time_min < 10 else str(time_min)
	var time_sec = Global.time - floor(Global.time/60)*60
	var time_sec_format = "0" + str(time_sec) if time_sec < 10 else str(time_sec)
	$Label3.text = time_min_format + ":" + time_sec_format
	$Label5.text = str(Global.score)

	
func _on_exitgame_pressed():
	get_tree().quit()


func _on_Button_pressed():
	get_tree().change_scene("res://src/stage.tscn")

func _on_Button2_pressed():
	get_tree().quit()
