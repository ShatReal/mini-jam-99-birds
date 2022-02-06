extends StaticBody2D


const HEIGHT := 10
const SPEED := 100

var is_leaf := false
var spike: Node


func _ready() -> void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta


func set_size(length) -> void:
	$CollisionShape2D.shape.extents.x = length / 2
# warning-ignore:integer_division
	$CollisionShape2D.shape.extents.y = HEIGHT / 2
	$CollisionShape2D.position.x = length / 2
# warning-ignore:integer_division
	$CollisionShape2D.position.y = HEIGHT / 2
	$TextureRect.rect_size.x = length
	$TextureRect.rect_size.y = HEIGHT
	match length:
		28:
			$TextureRect.texture = preload("res://sprites/log_0.png")
		32:
			$TextureRect.texture = preload("res://sprites/leaf.png")
			is_leaf = true
		43:
			$TextureRect.texture = preload("res://sprites/log_1.png")
		60:
			$TextureRect.texture = preload("res://sprites/log_2.png")


func delayed_queue_free() -> void:
	$Timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
