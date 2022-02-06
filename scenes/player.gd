extends KinematicBody2D


const SPEED := 100
const GRAVITY := 256
var jump_force := 125

var velocity := Vector2()
var can_double_jump = true


func _physics_process(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	velocity.x = input * SPEED
	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and can_double_jump:
		can_double_jump = false
		velocity.y = -jump_force
		if is_on_floor():
			$AudioStreamPlayer.stream = preload("res://sound/Jump.wav")
			$AudioStreamPlayer.play()
		else:
			var arr := [
				preload("res://sound/Flap.wav"),
				preload("res://sound/Flap(1).wav"),
			]
			$AudioStreamPlayer.stream = arr[randi()%arr.size()]
			$AudioStreamPlayer.play()
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().get("is_leaf") == true:
			$RayCast2D.get_collider().set_physics_process(true)
			if $RayCast2D.get_collider().spike:
				$RayCast2D.get_collider().spike.set_physics_process(true)
	if is_on_floor():
		can_double_jump = true
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Animation
	if is_on_floor():
		if input:
			$Sprite.play("run")
		else:
			$Sprite.play("idle")
	else:
		$Sprite.play("jump")
	if input != 0:
		$Sprite.flip_h = input < 0
