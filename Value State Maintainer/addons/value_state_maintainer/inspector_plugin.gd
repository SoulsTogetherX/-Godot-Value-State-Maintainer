extends EditorInspectorPlugin

const COLOR_EDITOR = preload("res://addons/value_state_maintainer/scenes/property editors/color_editor/color_editor.gd")
const NUMBER_EDITOR = preload("res://addons/value_state_maintainer/scenes/property editors/value_editors/number_editor/number_editor.gd")

func _can_handle(object: Object) -> bool:
	return true

func _parse_property(
		object: Object,
		type: Variant,
		name: String,
		hint_type: PropertyHint,
		hint_string: String,
		usage_flags: int,
		wide: bool
	) -> bool:
	match type:
		TYPE_COLOR:
			var editor : Control = COLOR_EDITOR.new()
			editor.init()
			add_property_editor(name, editor)
			return true
		TYPE_INT:
			if hint_type != PROPERTY_HINT_NONE: return false
			
			var editor : Control = NUMBER_EDITOR.new()
			editor.init()
			add_property_editor(name, editor)
			return true
	
	return false
