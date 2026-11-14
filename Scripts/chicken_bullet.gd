extends CharacterBody2D

const SPEED = 700.0

var direction:Vector2

func _physics_process(delta: float) -> void:
	
	velocity = direction * SPEED * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
		
