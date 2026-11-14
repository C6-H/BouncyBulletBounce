extends CharacterBody2D

const SIGHT = 300

@onready var player = %Player
@onready var walk_timer: Timer = $walkTimer

var player_distance: float
var seen: bool = false
var attitude: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sight_check()
	if seen:
		if attitude == 1:
			walk_timer.start()
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
	


func _on_walk_timer_timeout() -> void:
	if randi_range(0, 2) == 1:
		attitude = 2
		
