extends PathFollow2D

@export var speed : int = 1

func _process(delta: float) -> void:
	progress_ratio = fmod(progress_ratio + (speed * delta * 0.1), 1.0)
