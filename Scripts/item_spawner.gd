extends Node2D

@export var pickup_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(Vector2(-200, -500), Vector2(1000, 500))
@export var max_spawn_count: int = 30
@export var spawn_delay: float = 2.0  # segundos entre spawns

var current_spawned: int = 0
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	spawn_timer.wait_time = spawn_delay
	spawn_timer.timeout.connect(spawn_pickup_item)
	spawn_timer.start()

func spawn_pickup_item():
	if current_spawned >= max_spawn_count:
		return

	var space_state = get_world_2d().direct_space_state

	for i in range(10):  # intenta hasta 10 veces
		var rand_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)

		var params = PhysicsPointQueryParameters2D.new()
		params.position = rand_pos
		params.collision_mask = 2  # asegúrate de que casas/cercas estén en la capa 2

		var result = space_state.intersect_point(params)

		if result.is_empty():
			var item = pickup_scene.instantiate()
			item.position = rand_pos
			get_tree().current_scene.add_child(item)
			current_spawned += 1
			break
