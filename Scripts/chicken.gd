extends CharacterBody2D

const SIGHT = 300

@onready var player = %Player
@onready var walk_timer: Timer = $walkTimer

const SPEED = 900.0

var player_distance: float
var seen: bool = false
var attitude: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sight_check()
	if seen:
		if attitude == 1:
			walk_timer.start()
			walk()
		elif attitude == 2:
			shoot()
			attitude = 1
			
		
		
func sight_check():
	var to_player_vector = player.position - global_position
	player_distance = sqrt(to_player_vector.x ** 2 + to_player_vector.y ** 2)
	if player_distance < SIGHT:
		seen = true

func shoot():
	var bullet = preload("uid://6r15a5ny5d4k")
	var x = cos(rotation)
	var y = sin(rotation)
	add_child(bullet)
	bullet.direction = Vector2(x, y)
	
func walk():
	var space = get_world_2d().direct_space_state
	var ray = PhysicsRayQueryParameters2D.create(global_position, player.position)
	var data = space.intersect_ray(ray)
	var walk_goal: Vector2
	if not data.get("collider") == player:
		look_at(player)
		rotation -= 90
		var object_rel = data.get("collider").global_position - global_position
		var radius = sqrt(object_rel.x ** 2 + object_rel.y ** 2)
		for i in range(90):
			var x = cos(deg_to_rad(i - 90))
			var y = sin(deg_to_rad(i - 90))
			var point_to_check = radius * Vector2(x, y)
			ray = PhysicsRayQueryParameters2D.create(point_to_check.global_position, player.position)
			data = space.intersect_ray(ray)
			if data.get("collider") == player:
				walk_goal == point_to_check
			else:
				x = cos(-deg_to_rad(i - 90))
				y = sin(-deg_to_rad(i - 90))
				point_to_check = radius * Vector2(x, y)
				ray = PhysicsRayQueryParameters2D.create(point_to_check.global_position, player.position)
				data = space.intersect_ray(ray)
				if data.get("collider") == player:
					walk_goal == point_to_check
	position += walk_goal * SPEED * get_physics_process_delta_time()
func _on_walk_timer_timeout() -> void:
	if randi_range(0, 2) == 1:
		attitude = 2
		
