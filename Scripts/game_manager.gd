extends Node

const ROOMS = ["res://Scenes/Rooms/l_shaped_room_1.tscn", "res://Scenes/Rooms/square_room_1.tscn"]
const SPAWN = "res://Scenes/Rooms/spawn_room.tscn"


var score = 0
var played_rooms = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func next_room():
	var next_tag = -1
	while next_tag in played_rooms or next_tag == -1:
		next_tag = randi_range(0, len(ROOMS))
	
	played_rooms.append(next_tag)
