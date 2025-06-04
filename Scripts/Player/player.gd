extends CharacterBody2D

class_name Player

@onready var weapon: Node2D = $weapon
@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var oxygenBar: TextureProgressBar = get_node("../CanvasLayer/oxygenBar")
@onready var oxygenTimer: Timer = $OxygenTimer
var main
var isAttacking: bool = false

const SPEED = 5000.0
var oxygen := 40

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	
	if Input.is_action_just_pressed("left_hand_action") or Input.is_action_just_pressed("right_hand_action"):
		animated_sprite_2d.play_attack_animation(velocity)
		isAttacking = true
		await animated_sprite_2d.attack_animation_finished
		isAttacking = false
	
	if not isAttacking:
		if velocity != Vector2.ZERO:
			animated_sprite_2d.play_movement_animation(velocity)
		else:
			animated_sprite_2d.play_idle_animation()

	move_and_slide()

func _ready():
	add_to_group("player")
	oxygenBar.value = oxygen
	oxygenTimer.start()
	main = get_parent()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
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
	if !FileAccess.file_exists(ruta):
		dataScript.crear_csv(ruta)
	data = str(dataScript.buscarUltimaPartida()) + "," + ",".join(data)
	dataScript.agregar_linea_csv(ruta, data)

func increase_oxygen(amount: int):
	oxygen += amount
	oxygen = clamp(oxygen, 0, 40)
	oxygenBar.value = oxygen
