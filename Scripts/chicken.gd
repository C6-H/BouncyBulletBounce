extends CharacterBody2D

const SIGHT = 300

@onready var player = %Player
@onready var walk_timer: Timer = $walkTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var line_2d: Line2D = $Line2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var path_timer: Timer = $PathTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

const SPEED = 300.0

var player_distance: float
var seen: bool = false
var attitude: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.target_position = player.position

func _physics_process(_delta: float) -> void:
	if not get_world_2d().direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, player.global_position)).get("collider") == player:
		if !navigation_agent_2d.is_target_reached():
			var nav_point_direction = to_local(navigation_agent_2d.get_next_path_position())
			velocity = nav_point_direction * SPEED * get_physics_process_delta_time()
			attitude = 1
		else:
			velocity = Vector2(0, 0)
			attitude = 2
	else:
		velocity = Vector2(0, 0)
		attitude = 2
	
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(player.position)
	sight_check()
	if seen:
		if attitude == 1:
			walk()
		if attitude == 2:
			if shoot_timer.is_stopped():
				shoot_timer.start()
		else:
			shoot_timer.stop()
		

func walk():
	pass
func sight_check():
	var to_player_vector = player.position - global_position
	player_distance = sqrt(to_player_vector.x ** 2 + to_player_vector.y ** 2)
	if player_distance < SIGHT:
		seen = true

func shoot():
	var bullet = preload("uid://6r15a5ny5d4k").instantiate()
	bullet.position = position
	bullet.rotation = rotation - PI/2
	while rotation < 0:
		rotation += 2*PI
	var x = cos(rotation)
	var y = sin(rotation)
	bullet.direction = Vector2(x, y)
	get_parent().add_child(bullet)

		


func _on_shoot_timer_timeout() -> void:
	shoot()


func _on_path_timer_timeout() -> void:
	if navigation_agent_2d.target_position != player.position:
		navigation_agent_2d.target_position = player.position
	path_timer.start()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/Bullet.tscn":
		die()


func die():
	audio_player.play()
	$Sprite2D.texture = preload("uid://7ca8mqqe0x8f")
	var blood = Sprite2D.new()
	get_parent().get_parent().add_child(blood)
	blood.texture = preload("uid://7ca8mqqe0x8f")
	blood.global_position = global_position
	audio_player.play()
	visible = false
	


func _on_audio_stream_player_finished() -> void:
	queue_free()
