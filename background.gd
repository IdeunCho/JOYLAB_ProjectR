extends Node2D
var game_started := false
var chunks := []
var start_time = 0
var elapsed_time = 0

signal beat
signal music_start
signal spawn_obstacle

export var bpm := 120
export var chunk_scene: PackedScene
export var chunk_distance := 1280
export var chunk_spawn_y := -1280
export var chunk_despawn_y := 1920
export var scroll_speed := 400
export var scroll_per_beat := 200

var music_beat = [ 2.02, 2.902, 3.367, 3.901, 4.528, 4.992, 5.48, 5.991, 6.491, 7.009, 7.492, 7.992, 8.494, 9.009, 9.504, 10.021, 10.529, 11.03, 11.529, 12.022, 12.513, 13.006, 13.506, 14.006, 14.494, 14.995, 15.496, 15.997, 16.496, 16.996, 17.495, 17.996, 18.506, 19.001, 19.511, 20.011, 20.513, 21.022, 21.525, 22.029, 22.521, 23.02, 23.519, 24.007, 24.503, 25.006, 25.512, 26.01, 26.506, 27.006, 27.509, 28.006, 28.503, 29.008, 29.508, 30.006, 30.513, 31.013, 31.517, 32.017, 32.513, 33.013, 33.511, 34.011, 34.507, 35.011, 35.504, 36.005, 36.507, 37.008, 37.51, 38.01, 38.51, 39.011, 39.507, 40.006, 40.506, 41.009, 41.504, 42.005, 42.513, 43.013, 43.513, 44.013, 44.512, 45.007, 45.507, 46.005, 46.512, 47.008, 47.509, 48.006, 48.506, 49.006, 49.507, 50.007, 50.507, 51.01, 51.509, 52.01, 52.513, 53.01, 53.51, 54.008, 54.51, 55.008, 55.508, 56.008, 56.513, 57.011, 57.514, 58.011, 58.514, 59.011, 59.512, 60.011, 60.51, 61.006, 61.51, 62.013, 62.506, 63.005, 63.506, 64.004, 64.505, 65.006, 65.507, 66.01, 66.507, 67.006, 67.504, 68.006, 68.507, 69.006, 69.507, 70.008, 70.507, 71.009, 71.507, 72.007, 72.509, 73.007, 73.506, 74.006, 74.506, 75.008, 75.507, 76.007, 76.506, 77.006, 77.507, 78.008, 78.507, 79.007, 79.507, 80.008, 80.508, 81.01, 81.507, 82.01, 82.51, 83.008, 83.508, 84.006, 84.506, 85.006, 85.507, 86.008, 86.508, 87.008, 87.507, 88.008, 88.508, 89.008, 89.508, 90.006, 90.507, 91.008, 91.507, 92.008, 92.507, 93.006, 93.507, 94.006, 94.507, 95.008, 95.507, 96.008, 96.507, 97.008, 97.507, 98.008, 98.507, 99.008, 99.507, 100.008, 101.507, 102.008, 102.507, 103.008, 103.507, 104.008, 104.507, 105.008, 105.507, 106.008, 106.507, 107.008, 107.507, 108.008, 108.507, 109.008, 109.507, 110.008, 110.507, 111.008, 111.507, 112.008, 112.507, 113.008, 113.507, 114.008, 114.507, 115.008, 115.507, 116.008, 116.507, 117.008, 117.507, 118.008, 118.507, 119.008, 119.507, 120.008, 120.507, 121.008, 121.507, 122.008, 122.507, 123.008, 123.507, 124.008, 124.507, 125.008, 125.507, 126.008, 126.507, 127.008, 127.507, 128.008, 128.507, 129.008 ]


var music_beat_number = 0
var beat_interval := 60.0 / bpm
var beat_timer := 0.0

func _ready():

	start_countdown()
	yield(get_tree().create_timer(3.2), "timeout")
	start_time = OS.get_ticks_msec()
	print((music_beat[music_beat_number]))
	print(elapsed_time)
	
func start_countdown():
	yield(get_tree().create_timer(1), "timeout")
	print("3")
	yield(get_tree().create_timer(1), "timeout")
	print("2")
	yield(get_tree().create_timer(1), "timeout")
	print("1")
	yield(get_tree().create_timer(1), "timeout")
	print("Start!")
	emit_signal("music_start")
	game_started = true
	spawn_initial_chunks()
	beat_timer = 0.0

func spawn_initial_chunks():
	for i in range(3):
		var chunk = chunk_scene.instance()
		add_child(chunk)
		chunk.position = Vector2(0, chunk_spawn_y + i * chunk_distance)
		chunks.append(chunk)

func _process(delta):


	elapsed_time = (OS.get_ticks_msec() - start_time) / 1000.0
	
	if not game_started:
		return
		
	for chunk in chunks:
		chunk.position.y += scroll_speed * delta
		
	for chunk in chunks:
		if chunk.position.y > chunk_despawn_y:
			chunk.position.y = chunk_spawn_y
			
		
	if music_beat_number < music_beat.size():
		var beat_time = music_beat[music_beat_number]
		if abs(elapsed_time - beat_time) <= 0.02:
				emit_signal("spawn_obstacle")
				print("Spawn at:", elapsed_time)
				music_beat_number += 1
		

