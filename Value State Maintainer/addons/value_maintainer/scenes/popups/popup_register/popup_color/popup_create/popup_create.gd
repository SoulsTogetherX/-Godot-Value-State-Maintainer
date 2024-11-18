@tool
extends ConfirmationDialog

const ERROR_COLOR := Color.RED
const VAILD_COLOR := Color.LIME_GREEN

const COLOR_ACCESS := preload("res://addons/value_maintainer/global_modals/color_access.gd")
const FILENAME_VALIDATOR := preload("res://addons/value_maintainer/global_modals/filename_vaildator.gd")

@onready var titleLabel: Label = $VBoxContainer/Title
@onready var errorLabel: Label =  $VBoxContainer/MarginContainer/PanelContainer/Error
@onready var suffix: Label = $VBoxContainer/BoxContainer/PanelContainer/MarginContainer/Suffix
@onready var filenameInput: LineEdit = $VBoxContainer/BoxContainer/FileInput

var _filepath : String
var _longname : String
var _extention : String

func _ready() -> void:
	filenameInput.text_changed.connect(_check_error)
	
	set_process_input(false)
	get_ok_button().pressed.connect(set_process_input.bind(false))

func set_labels(valueType : int, filePath : String) -> void:
	_filepath = filePath
	_extention = FILENAME_VALIDATOR.get_extension(valueType)
	if valueType != TYPE_DICTIONARY: _extention = "." + _extention
	_longname = FILENAME_VALIDATOR.get_long_name(valueType)
		
	title = "Create " + _longname
	titleLabel.text = "Create new " + _longname + " in " + filePath
	filenameInput.text = "New " + _longname
	suffix.text = _extention
	_check_error(filenameInput.text)

func show_select() -> void:
	get_ok_button().release_focus()
	filenameInput.call_deferred("grab_focus")
	show()
	set_process_input(true)

func get_filename() -> String:
	return filenameInput.text + _extention
func get_filepath() -> String:
	return _filepath + "/" + get_filename()

func _check_error(fileName : String) -> void:
	if fileName.is_empty():
		errorLabel.add_theme_color_override("font_color", ERROR_COLOR)
		errorLabel.text = "• " + _longname + " name cannot be empty"
		get_ok_button().disabled = true
	else:
		var vaild : bool = COLOR_ACCESS.path_vaild(_filepath, fileName + _extention)
		if vaild:
			errorLabel.add_theme_color_override("font_color", VAILD_COLOR)
			errorLabel.text = "• " + _longname + " name is vaild"
		else:
			errorLabel.add_theme_color_override("font_color", ERROR_COLOR)
			errorLabel.text = "• " + _longname + " with that name already exists"
		
		get_ok_button().disabled = !vaild

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_ok_button().pressed.emit()
