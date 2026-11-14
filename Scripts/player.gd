extends CharacterBody2D
var bullet_scene = preload("res://Scenes/Bullet.tscn")
@onready var gun: Marker2D = $Gun


const SPEED = 13500.0

var charging = false
@onready var reload_timer: Timer = $"Reload timer"
var bullet_speed = 0

var elapsed_time = 0.0

func _physics_process(delta: float) -> void:
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
		if elapsed_time < 5.0:
			elapsed_time += delta
		Engine.time_scale = 0.5
	
	if Input.is_action_just_released("Shoot") and reload_timer.is_stopped():
		print("shoot")
		shoot()

	if Input.is_action_just_released("Shoot"):
		charging = false
		if elapsed_time >= 5.0:
			bullet_speed = elapsed_time * 500
		else:
			bullet_speed = 2500
		Engine.time_scale = 1
		elapsed_time = 0
		
		reload_timer.start()
	
	
	look_at(get_global_mouse_position())
	rotation_degrees -= 90

func shoot():
	var bullet = bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.transform = gun.global_transform
	bullet.velocity = gun.global_transform.x * bullet_speed
