extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var max_bounces = 30
var bounces = 0
var speed: float = 10
var collidable = true
var last_pos: Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if last_pos != position:
		last_pos = position
		look_at(last_pos)
		rotate(PI - PI/6)
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounces += 1
		collidable = false
	
	if bounces > max_bounces:
		queue_free()
	
	rotation = velocity.angle() + 90


func _on_collision_cooldown_timeout() -> void:
	collidable = true
