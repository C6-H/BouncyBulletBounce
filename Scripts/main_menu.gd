extends Control

signal startgame

func _on_start_pressed() -> void:
	emit_signal("startgame")



func _on_exit_pressed() -> void:
	get_tree().quit()
