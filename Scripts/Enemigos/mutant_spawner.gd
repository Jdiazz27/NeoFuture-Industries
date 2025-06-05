extends Node2D

@export var enemy_scene: PackedScene
@export var min_spawn_x: float = -380
@export var max_spawn_x: float = 245
@export var min_spawn_y: float = -160
@export var max_spawn_y: float = 280

@export var max_spawn_count: int = 1000
var current_spawned: int = 0

func spawn_enemy():
	if current_spawned >= max_spawn_count:
		return

	var rand_pos = Vector2(
		randf_range(min_spawn_x, max_spawn_x),
		randf_range(min_spawn_y, max_spawn_y)
	)

	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = rand_pos
	var result = space_state.intersect_point(params)

	if result.is_empty():
		var enemy = enemy_scene.instantiate()
		enemy.position = rand_pos
		get_tree().current_scene.add_child(enemy)
		current_spawned += 1
