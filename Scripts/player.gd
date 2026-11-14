extends CharacterBody2D


const SPEED = 13500.0

var charging = false
@onready var reload_timer: Timer = $"Reload timer"
var bullet_speed = 0

var elapsed_time = 0.0

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity = Vector2(0,0)
	

	move_and_slide()


func _process(delta: float) -> void:
	if Input.is_action_pressed("Shoot") and reload_timer.is_stopped():
		charging = true
	
	if charging == true:
		elapsed_time += delta
		Engine.time_scale = 0.5
	
	if Input.is_action_just_released("Shoot"):
		print("shoot")
		charging = false
		if elapsed_time <= 2.5:
			bullet_speed = elapsed_time * 5000
		else:
			bullet_speed = 25000
		Engine.time_scale = 1
		
		reload_timer.start()
	
	
	look_at(get_global_mouse_position())
	rotation_degrees -= 90
