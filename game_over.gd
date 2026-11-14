extends CanvasLayer

func _ready() -> void:
	visible = false

func show_game_over() -> void:
	visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("Jump"):
		_on_button_pressed()
