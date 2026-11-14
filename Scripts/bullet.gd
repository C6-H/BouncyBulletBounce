extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var max_bounces = 3
var bounces = 0

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounces += 1
	
	if bounces > max_bounces:
		queue_free()
	
	rotation = velocity.angle() + 90
