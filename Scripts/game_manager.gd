extends Node

const ROOMS = ["res://Scenes/Rooms/l_shaped_room_1.tscn", "res://Scenes/Rooms/square_room_1.tscn", "res://Scenes/Rooms/hallways.tscn"]
const SPAWN = "res://Scenes/Rooms/spawn_room.tscn"


var score = 0
var played_rooms = []
var current_room = 0
var save_path = "res://other/save_data/Save.tres"


func load_save():
	if FileAccess.file_exists(save_path):
		var save_data = FileAccess.open(save_path, FileAccess.READ)

func _on_main_menu_startgame() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/spawn_room.tscn")
	var save = {
	save_score = score,
	save_current_room = current_room, 
	save_played_rooms = played_rooms
	}

func _ready() -> void:
	load_save()

func next_room():
	var next_tag = -1
	if len(played_rooms) != len(ROOMS):
		while next_tag in played_rooms or next_tag == -1:
			next_tag = randi_range(0, len(ROOMS))
		played_rooms.append(next_tag)
	return next_tag

func _on_exit_load_room() -> void:
	current_room += 1
	var save = {
		save_score = score,
		save_current_room = current_room, 
		save_played_rooms = played_rooms
	}
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(save)
	
	var next_room = ROOMS[next_room()]
	get_tree().change_scene_to_file(next_room)
