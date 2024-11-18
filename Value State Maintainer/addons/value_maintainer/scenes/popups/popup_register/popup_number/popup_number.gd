@tool
extends Window

signal unregister
signal register(value)

var _get_values : Callable
var _light_editor : Control
var _dark_editor : Control

func _ready() -> void:
	close_requested.connect(hide)

func _on_unregister() -> void:
	unregister.emit()
	close_requested.emit()
func _on_register() -> void:
	register.emit(_get_values.call())
	close_requested.emit()

func init(light_editor : Control, dark_editor : Control, get_values : Callable) -> void:
	if _light_editor: _light_editor.queue_free()
	_light_editor = light_editor
	if _dark_editor: _dark_editor.queue_free()
	_dark_editor = dark_editor
	
	var docker : VBoxContainer = $"VBoxContainer/Value Dialog/Docker Margin/Docker"
	docker.get_node("Light").add_child(light_editor)
	docker.get_node("Dark").add_child(dark_editor)
	
	_get_values = get_values
func get_values() -> Array:
	return _get_values.call()
