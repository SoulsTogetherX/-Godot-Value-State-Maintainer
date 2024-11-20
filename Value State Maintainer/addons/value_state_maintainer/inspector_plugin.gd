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
		TYPE_INT:#, TYPE_FLOAT:
			var range_args = [
				0,
				100,
				1 if type == TYPE_INT else TYPE_FLOAT,
				true,
				true
			]
			
			if hint_type == PROPERTY_HINT_RANGE:
				var num : int = 0
				var args := hint_string.split(",", false)
				for arg in args:
					if arg.is_valid_int():
						if num >= 3: continue
						range_args[num] = int(arg.to_int())
						num += 1
					elif arg == "allow_greater":
						range_args[3] = true
					elif arg == "allow_lesser":
						range_args[4] = true
			elif hint_type != PROPERTY_HINT_NONE:
				return false
			
			var editor : Control = NUMBER_EDITOR.new()
			editor.init(range_args)
			add_property_editor(name, editor)
			return true
	
	return false
