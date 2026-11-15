extends Node

const ROOMS = ["res://Scenes/Rooms/l_shaped_room_1.tscn", "res://Scenes/Rooms/hallways.tscn", "res://Scenes/Rooms/circular_shapedroom.tscn", "res://Scenes/Rooms/room_2.tscn"]
const SPAWN = "res://Scenes/Rooms/spawn_room.tscn"


var score = 0
var played_rooms = []
var save_path = "res://other/save_data/Save.tres"
var save: Dictionary
var save_data: FileAccess
@onready var gate = %Gate
@onready var chickens = %Chickens
@onready var player: CharacterBody2D = $"../Player"
func load_save():
	if FileAccess.file_exists(save_path):
		save_data = FileAccess.open(save_path, FileAccess.READ)
	
func _on_main_menu_startgame():
	get_tree().change_scene_to_file("res://Scenes/Rooms/spawn_room.tscn")
	save = {
	save_score = 0,
	save_played_rooms = 0
	}

func _ready() -> void:
	load_save()
	if gate:
		gate.load_room.connect(_on_gate_load_room)
	if player:
		player.dead.connect(player_dead)
		
	

func player_dead():
	_on_main_menu_startgame()
	
func next_room():	
	var next_tag = -1
	if len(played_rooms) != len(ROOMS):
		while next_tag in played_rooms or next_tag == -1:
			next_tag = randi_range(0, len(ROOMS))
		played_rooms.append(next_tag)
	return next_tag

func _process(delta: float) -> void:
	if chickens:
		print(chickens.get_child_count())
		print(chickens.get_children())
		if chickens.get_child_count() == 0:
			gate.openUp()



func _on_gate_load_room():
	var save = {
		save_score = score,
		save_played_rooms = played_rooms
	}
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(save)
	
	print(len(ROOMS))
	var next_room = ROOMS[next_room() - 1]
	get_tree().change_scene_to_file(next_room)
	
