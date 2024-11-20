@tool
class_name PopupRegister extends Window

signal register(
	is_array : bool,
	obj : Object,
	property : StringName,
	value : Variant,
	index : int
)
signal unregister(
	is_array : bool,
	obj : Object,
	property : StringName,
	index : int
)

var editor_ref : BaseThemeEditorProperty

func _ready() -> void:
	close_requested.connect(hide)

func _on_closed_pressed() -> void:
	close_requested.emit()
func _emit_closed() -> void:
	close_requested.emit()
func _on_register(value : Variant) -> void:
	if editor_ref.is_array:
		register.emit(
			true,
			editor_ref.array_object,
			editor_ref.property_path,
			value,
			editor_ref.index
		)
	else:
		register.emit(
			false,
			editor_ref.get_edited_object(),
			editor_ref.get_edited_property(),
			value,
			-1
		)
	close_requested.emit()
func _on_unregister() -> void:
	if editor_ref.is_array:
		unregister.emit(
			true,
			editor_ref.array_object,
			editor_ref.property_path,
			editor_ref.index
		)
	else:
		unregister.emit(
			false,
			editor_ref.get_edited_object(),
			editor_ref.get_edited_property(),
			-1
		)
	close_requested.emit()
