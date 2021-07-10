extends KinematicBody2D

export var speed = Vector2(200,750)
var time1 = 0
export var velocity = Vector2(0,0)
export var gravity = 1000
var health = 1
var screen_size
var score1 = 0
var fire_dir_left = true
onready var Bullet = preload("res://src/bullet/bullet.tscn") 
var fire_cooldown = 0
var fire_cooldown_started = false

func _ready() -> void:
	get_node("Timer").start(1)

func calcu_move_vel(liner_vel: Vector2,dir: Vector2,speed:Vector2) -> Vector2:
	var new_vel:= liner_vel
	new_vel.x = speed.x *dir.x
	new_vel.y += gravity * get_physics_process_delta_time()
	if dir.y == -1.0:
		new_vel.y = speed.y * dir.y
	return new_vel

func _process(delta: float) -> void:
	var pos = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		pos.x += 1
		fire_dir_left = true
	elif Input.is_action_pressed("ui_left"):
		pos.x -= 1
		fire_dir_left = false
	else:
		$AnimatedSprite.play("idle")
		
	if fire_cooldown_started:
		fire_cooldown += 1
	
	if fire_cooldown >= 30:
		fire_cooldown_started = false
		fire_cooldown = 0
		
	if Input.is_action_pressed("fire"):
		if !fire_cooldown_started:
			fire_cooldown_started = true
			
			var bullet =  Bullet.instance()
			get_node("/root/Node2D").add_child(bullet)
			bullet.global_position.y = $AnimatedSprite.global_position.y 
			
			if fire_dir_left:
				bullet.global_position.x = $AnimatedSprite.global_position.x
				bullet.apply_impulse(Vector2(),Vector2(1025,0.0015))
			else:
				bullet.global_position.x = $AnimatedSprite.global_position.x
				bullet.apply_impulse(Vector2(),Vector2(-1025,0.0015))
				
			$fire.play()
			yield(get_tree().create_timer(1.0), "timeout")
			$fire.stop()

	if pos.length() > 0:
		pos = pos.normalized() * speed * delta
		get_node("AnimatedSprite").play("walk")
	else:
		get_node("AnimatedSprite").play("idle")

	if pos.x != 0:
		get_node("AnimatedSprite").animation ="walk"
		get_node("AnimatedSprite").flip_v = false
		get_node("AnimatedSprite").flip_h = pos.x < 0

func _physics_process(delta:float)-> void:
	var dir: = get_dir()
	velocity = calcu_move_vel(velocity,dir,speed)
	velocity = move_and_slide(velocity,Vector2.UP)

func get_dir() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1.0 if Input.get_action_strength("ui_up") and is_on_floor() else 1.0
		)

func _on_Area2D_body_entered(body: PhysicsBody2D):
	print(body)
	if body.name == "Boss":
		minusHP(body.global_position.x, get_node("Area2D"), "Boss")
	else:
		minusHP(body.global_position.x, get_node("Area2D"), "enemy")
		
func minusHP(entity_x: float, PArea2D: Node2D, DamagedFrom: String) -> void:
	if DamagedFrom == "Boss":
		health -= 1
	else:
		health -= 1
	if(health <= 0):
		get_node("CollisionShape2D").disabled = true
		queue_free()
		get_tree().change_scene("res://src/HUD/gameover.tscn")

func _on_Door_body_entered(body):
	self.global_position.x = 480
	self.global_position.y = 3500

func _on_Timer_timeout():
	Global.time += 1
	time1 += 1
	var time_min = floor(time1/60)
	var time_min_format = "0" + str(time_min) if time_min < 10 else str(time_min)
	
	var time_sec = time1 - floor(time1/60)*60
	var time_sec_format = "0" + str(time_sec) if time_sec < 10 else str(time_sec)
	$Camera2D/Label2.text = time_min_format + ":" + time_sec_format


func _on_boss_bossbekill():
	Global.score += 10
	score1 += 10
	$Camera2D/Label4.text = str(score1)
	get_node("Timer").stop()
	get_tree().change_scene("res://src/GameWin.tscn")


func _on_enemy1_enemy1bekill():
	Global.score += 1
	score1 += 1
	$Camera2D/Label4.text = str(score1)


func _on_enemy2_enemy2bekill():
	Global.score += 2
	score1 += 2
	$Camera2D/Label4.text = str(score1)



