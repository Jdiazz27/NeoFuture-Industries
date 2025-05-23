extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $Inventory
#@onready var weapon = $sword
#@onready var hit_box = $HitBox
@onready var oxygenBar: TextureProgressBar = get_node("../CanvasLayer/oxygenBar")
@onready var oxygenTimer: Timer = $OxygenTimer
var main

const SPEED = 5000.0
var oxygen := 40

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()
	
	move_and_slide()

#func _process(delta):
	#if Input.is_action_just_pressed("attack"):
		#hit_box.monitoring = true
		#await get_tree().create_timer(0.2).timeout
		#hit_box.monitoring = false

func _ready():
	add_to_group("player")
	oxygenBar.value = oxygen
	oxygenTimer.start()
	main = get_parent()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
		inventory.add_item(area.inventory_item, area.stacks)
		main.add("monedas_list", "moneda")
		area.queue_free()

func _on_oxygen_timer_timeout() -> void:
	if oxygen > 0:
		oxygen -= 5
		oxygenBar.value = oxygen
	if oxygen <= 0:
		die()

func die():
	get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")
	var ruta = "res://Archivos/datos.csv"
	var dataScript = preload("res://Scripts/guardarDatos.gd")
	dataScript = Datos.new()
	
	var data = main.getData()
	print(data)
	data = str(dataScript.buscarUltimaPartida()) + "," + ",".join(data)
	print(data)
	if FileAccess.file_exists(ruta):
		dataScript.agregar_linea_csv(ruta, data)
	else:
		dataScript.crear_csv(ruta)

func increase_oxygen(amount: int):
	oxygen += amount
	oxygen = clamp(oxygen, 0, 40)
	oxygenBar.value = oxygen
