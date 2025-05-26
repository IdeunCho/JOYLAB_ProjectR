extends Node

signal perfect_beat_pressed
signal spawn_1
signal spawn_2
signal spawn_3

var last_spawn_time := -1.0
var judge_window := 1
var input_locked := false  # 입력 판정 잠금

func _ready():
	get_parent().connect("spawn_obstacle", self, "_on_background_spawn_obstacle")
	randomize()

func _on_background_spawn_obstacle():
	print("hi")
	last_spawn_time = OS.get_ticks_msec() / 1000.0
	input_locked = false  # 새로운 비트가 들어오면 입력 잠금 해제
	var options = [1, 2, 3]
	var obstacle_spawn_point = options[randi() % options.size()]
	if obstacle_spawn_point == 1:
		emit_signal("spawn_1")
	if obstacle_spawn_point == 2:
		emit_signal("spawn_2")
	if obstacle_spawn_point == 3:
		emit_signal("spawn_3")
	
func _process(delta):
	if Input.is_action_just_pressed("pressedSpaceBar") and not input_locked:
		input_locked = true  # 한 번 입력 들어오면 잠금
		var now = OS.get_ticks_msec() / 1000.0
		var error = abs(now - last_spawn_time)
		if error <= judge_window:
			print("🎯Perfect!")
			emit_signal("perfect_beat_pressed")
		elif error <= judge_window * 2:
			print("👍Good")
		elif error <= judge_window * 3:
			print("😬Bad")
		else:
			print("❌Miss")
