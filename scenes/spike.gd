extends Area2D


const SPEED := 100

func _ready() -> void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta
