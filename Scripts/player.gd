extends CharacterBody2D
var bullet_scene = preload("res://Scenes/Bullet.tscn")
@onready var gun: Marker2D = $Gun
@onready var reload_bar: ColorRect = $ReloadBar
@onready var aim: Line2D = $aim
@onready var ray: RayCast2D = $RayCast2D
@onready var gpu_particles: GPUParticles2D = $GPUParticles2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal dead

const SPEED = 13500.0

var charging = false
@onready var reload_timer: Timer = $"Reload timer"
var bullet_speed = 1000.0
var max_bounces = 3
var elapsed_time = 0.0

func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity = Vector2(0,0)
	

	move_and_slide()


func _process(delta: float) -> void:
	if charging:
		gpu_particles.visible = true
		audio_player.play()
		
	else:
		gpu_particles.visible = false
		audio_player.playing = false
	
	if !reload_timer.is_stopped():
		reload_bar.visible = true
		reload_bar.material.set_shader_parameter("height", reload_timer.time_left/reload_timer.wait_time)
	else:
		reload_bar.visible = false
	if Input.is_action_pressed("Shoot") and reload_timer.is_stopped():
		charging = true
		aimF()

	
	if charging == true:
		if elapsed_time < 5.0:
			elapsed_time += delta
		Engine.time_scale = 0.5
	


	
	if Input.is_action_just_released("Shoot") and reload_timer.is_stopped():
		shoot()
		aim.points = [Vector2(0, 0)]

	if Input.is_action_just_released("Shoot") and charging:
		charging = false
		if elapsed_time >= 5.0:
			bullet_speed = elapsed_time * 100
		else:
			bullet_speed = 1000
		Engine.time_scale = 1
		elapsed_time = 0
		
		reload_timer.start()
	
	
	look_at(get_global_mouse_position())
	rotation_degrees -= 90

func shoot():
	var bullet = bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.transform = gun.global_transform
	bullet.rotation = rotation
	bullet.speed = bullet_speed
	bullet.velocity = Vector2(cos(rotation + PI/2), sin(rotation + PI/2)) * bullet_speed

func ray_cast(from: Vector2, to: Vector2):
	var space = get_world_2d().direct_space_state
	var ray_new = PhysicsRayQueryParameters2D.create(from, to)
	var data = space.intersect_ray(ray_new)
	return data
	
func aimF():
	aim.points = [Vector2(0, 0), get_local_mouse_position()]

func death():
	emit_signal("dead")
