extends Node2D


const PLATFORM_Y_SPACING := 50
const PLATFORM_X_LOW := 32
const PLATFORM_X_HIGH := 224
const PLATFORM_GRACE := 256
const PLATFORM_LENGTHS := [28, 32, 43, 60]
const COIN_CHANCE := 0.1
const COIN_OFFSET := 10
const COIN_SCORE := 100
const START_OFFSET := 200
const LAVA_OFFSET := 128
const POINT_DIV := 4
const SPIKE_CHANCE := 0.1
const HALF_SPIKE_SIZE := 8

const Platform := preload("res://scenes/platform.tscn")
const Coin := preload("res://scenes/coin.tscn")
const Spike := preload("res://scenes/spike.tscn")

var lava_speed := 20
var platform_y := 150
var coin_score := 0
var max_height := -200


func _ready() -> void:
	randomize()
	$CanvasLayer/GameOver.hide()


func _physics_process(delta: float) -> void:
	$Lava.position.y -= lava_speed * delta
	if $Player.position.y + LAVA_OFFSET < $Lava.position.y:
		$Lava.position.y = $Player.position.y + LAVA_OFFSET
	$Walls.position.y = $Player.position.y
	while $Player.position.y - PLATFORM_GRACE < platform_y:
		make_platform()
	if -$Player.position.y > max_height:
		max_height = -$Player.position.y
# warning-ignore:integer_division
		$CanvasLayer/Label.text = str(coin_score + (max_height + START_OFFSET)/POINT_DIV)


func _on_Lava_body_entered(body: Node) -> void:
	if body.name == "Player":
		$Lava2.play()
		game_over()
	elif body.has_method("delayed_queue_free"):
		body.delayed_queue_free()
		

func game_over() ->void:
	$CanvasLayer/GameOver/Score.text = "Score: %s" % [coin_score + (max_height + START_OFFSET)/POINT_DIV]
	$CanvasLayer/GameOver.show()
	$CanvasLayer/GameOver/Restart.grab_focus()
	get_tree().paused = true


func make_platform() -> void:
	var platform := Platform.instance()
	$Platforms.add_child(platform)
	var length: int = PLATFORM_LENGTHS[randi() % PLATFORM_LENGTHS.size()]
	platform.set_size(length)
	var x := int(rand_range(PLATFORM_X_LOW, PLATFORM_X_HIGH - length))
	platform.position.x = x
	platform.position.y = platform_y
	if randf() < COIN_CHANCE:
		var coin := Coin.instance()
		$Coins.add_child(coin)
# warning-ignore:integer_division
		coin.position.x = x + length / 2
		coin.position.y = platform_y - COIN_OFFSET
		coin.connect("body_entered", self, "on_coin_body_entered", [coin])
	elif randf() < SPIKE_CHANCE:
		var spike := Spike.instance()
		$Spikes.add_child(spike)
		spike.position.x = int(rand_range(HALF_SPIKE_SIZE, length - HALF_SPIKE_SIZE)) + x
		spike.position.y = platform_y
		spike.connect("body_entered", self, "on_spike_body_entered")
		platform.spike = spike
	platform_y -= PLATFORM_Y_SPACING


func on_coin_body_entered(body: Node, coin: Area2D) -> void:
	if body.name == "Player":
		coin_score += COIN_SCORE
		$CanvasLayer/Label.text = str(coin_score + (max_height + START_OFFSET)/POINT_DIV)
		coin.queue_free()
		$Coin.play()


func _on_Lava_area_entered(area: Area2D) -> void:
	area.queue_free()


func on_spike_body_entered(body: Node) ->void:
	if body.name == "Player":
		game_over()
