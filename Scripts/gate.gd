extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var open = false
signal load_room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("Open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animated_sprite_2d.frame == 2:
		open = true
	else:
		collision_shape_2d.disabled = false


func _on_area_entered(area: Area2D) -> void:
	if open:
		print("collider working")
		emit_signal("load_room")
		
