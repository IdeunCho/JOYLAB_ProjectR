extends Node2D

export var chunk_distance := 1280
export var chunk_spawn_y := -100
export var chunk_despawn_y := 1920
export var scroll_speed := 400
export var obstacle1scene: PackedScene

var spawn = 0
var obstacle_instance = null

func _on_perception_system_spawn_1():
	if obstacle1scene:
		obstacle_instance = obstacle1scene.instance()
		obstacle_instance.position = Vector2(120, -100) # y=100으로 테스트
		obstacle_instance.visible = true
		obstacle_instance.z_index = 1
		add_child(obstacle_instance)
		spawn = 1
		print("hi")

func _process(delta):
	if spawn == 1 and obstacle_instance:
		obstacle_instance.position.y += scroll_speed * delta
		if obstacle_instance.position.y > chunk_despawn_y:
			obstacle_instance.position.y = chunk_spawn_y
			spawn = 0
			# 필요하다면 아래 코드로 장애물 제거
			# remove_child(obstacle_instance)
			# obstacle_instance.queue_free()
			# obstacle_instance = null
