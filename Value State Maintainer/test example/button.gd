extends Button

@export var style : StyleBoxFlat

func _pressed() -> void:
	PalletAccessor.swap_state()
