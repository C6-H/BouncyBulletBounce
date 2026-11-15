extends Node

const ROOMS = ["res://Scenes/Rooms/l_shaped_room_1.tscn", "res://Scenes/Rooms/square_room_1.tscn", "res://Scenes/Rooms/hallways.tscn"]
const SPAWN = "res://Scenes/Rooms/spawn_room.tscn"


var score = 0
var played_rooms = []
var current_room = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_room()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func next_room():
	var next_tag = -1
	if current_room == 0:
		# loads spawn room
		pass
	elif len(played_rooms) != len(ROOMS):
		while next_tag in played_rooms or next_tag == -1:
			next_tag = randi_range(0, len(ROOMS))
		played_rooms.append(next_tag)
	elif len(played_rooms) > len(ROOMS):
		# loads end room
		pass

func _on_exit_load_room() -> void:
	current_room += 1
	var save = {
		save_score = score,
		save_current_room = current_room, 
		save_played_rooms = played_rooms
	}
	
