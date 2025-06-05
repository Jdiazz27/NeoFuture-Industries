extends Node2D

@export var trash_scene: PackedScene
@export var min_spawn_x: float = -380
@export var max_spawn_x: float = 245
@export var min_spawn_y: float = -160
@export var max_spawn_y: float = 280
@export var max_spawn_count: int = 1000
@export var spawn_delay: float = 3.0  # medido en egundos

@onready var spawn_timer: Timer = $SpawnTimer

var current_spawned: int = 0

func _ready():
	spawn_timer.wait_time = spawn_delay
	spawn_timer.timeout.connect(spawn_trash)
	spawn_timer.start()

func spawn_trash():
	if current_spawned >= max_spawn_count:
		return

	var space_state = get_world_2d().direct_space_state

	for i in range(10): 
		var rand_pos = Vector2(
			randf_range(min_spawn_x, max_spawn_x),
			randf_range(min_spawn_y, max_spawn_y)
		)

		var params = PhysicsPointQueryParameters2D.new()
		params.position = rand_pos
		var result = space_state.intersect_point(params)

		if result.is_empty():
			var trash = trash_scene.instantiate()
			trash.z_index = 5
			trash.position = rand_pos
			get_tree().current_scene.add_child(trash)
			current_spawned += 1
			
			break
