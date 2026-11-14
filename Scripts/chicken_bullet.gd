extends Area2D

const SPEED = 90.0

var direction:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	print("mmh")
