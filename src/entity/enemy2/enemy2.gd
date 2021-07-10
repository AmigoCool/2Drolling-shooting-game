extends KinematicBody2D
export var speed: = Vector2(300.0,750.0)
export var gra: = 1500.0
var vel: = Vector2.ZERO
var hit = 0
signal enemy2bekill

func _ready() -> void:
	vel.x = speed.x
	preload("res://src/global.gd")
	
func _on_Area2D_body_entered(body: PhysicsBody2D):

	if body.name != "player":
		hit +=1
		body.queue_free()
		if hit >= 5:
			get_node("CollisionShape2D").disabled = true
			emit_signal("enemy2bekill")
			queue_free()


func _physics_process(delta: float) -> void:
	$AnimatedSprite.play()
	vel.y += gra * delta
	if is_on_wall():
		vel.x *= -1.0
		$AnimatedSprite.set_flip_h(true)
		
	if vel.x != 0:
		get_node("AnimatedSprite").flip_v = false
		get_node("AnimatedSprite").flip_h = vel.x < 0
		
	vel.y = move_and_slide(vel, Vector2.UP).y
