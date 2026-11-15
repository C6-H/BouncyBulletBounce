extends CharacterBody2D

const SPEED = 500.0
signal kill_player

var direction:Vector2

func _physics_process(delta: float) -> void:
	
	velocity = direction * SPEED * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get("collider") == %Player:
			emit_signal("kill_player")
		queue_free()
		
