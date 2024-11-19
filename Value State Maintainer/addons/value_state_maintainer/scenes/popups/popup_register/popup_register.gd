@tool
class_name PopupRegister extends Window

signal register(obj : Object, property : StringName, value : Variant)
signal unregister(obj : Object, property : StringName)

var editor_ref : EditorProperty

func _ready() -> void:
	close_requested.connect(hide)

func _emit_closed() -> void:
	close_requested.emit()
func _on_register(value : Variant) -> void:
	register.emit(
		editor_ref.get_edited_object(),
		editor_ref.get_edited_property(),
		value
	)
	close_requested.emit()
func _on_unregister() -> void:
	unregister.emit(
		editor_ref.get_edited_object(),
		editor_ref.get_edited_property()
	)
	close_requested.emit()
