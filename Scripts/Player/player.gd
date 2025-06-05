extends CharacterBody2D

class_name Player

@onready var weapon: Node2D = $weapon
@onready var weapon_fist_child = weapon.get_child(0)
@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var oxygen_bar: TextureProgressBar = $CanvasLayer/oxygenBar
@onready var oxygen_timer: Timer = $OxygenTimer
@onready var hurt_box_collision: CollisionShape2D = $HurtBox/hurtBoxCollision

var main
var isAttacking: bool = false
var is_hurting:= false
var is_dying:= false
var oxygen := 40
const SPEED = 5000.0

func _physics_process(delta: float) -> void:
	if oxygen <= 0:
		die()
	
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
	await get_tree().process_frame

	animated_sprite_2d.connect("hurt_animation_finished", Callable(self, "_on_hurt_animation_finished"))

	if weapon_fist_child.has_method("disable_hitbox"):
		weapon_fist_child.disable_hitbox()
	
	add_to_group("player")
	oxygen_bar.value = oxygen
	oxygen_timer.start()
	main = get_parent()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
		main.add("oxigeno_list", "moneda")
		area.queue_free()

func _on_oxygen_timer_timeout() -> void:
	if oxygen > 0:
		oxygen -= 5
		oxygen_bar.value = oxygen
	if oxygen <= 0:
		die()

func die():
	if is_dying:
		return
	is_dying = true
	
	animated_sprite_2d.play("die")
	animation_player.play("die")
	await animation_player.animation_finished
	await get_tree().process_frame
	
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
	oxygen_bar.value = oxygen

func take_damage(damage):
	if is_hurting:
		return 

	is_hurting = true
	hurt_box_collision.call_deferred("set_disabled", true)
	animated_sprite_2d.play_hurt_animation(velocity)
	oxygen = oxygen - damage
	oxygen_bar.value = oxygen
	print("recibió ", damage, " puntos de daño")
	
	await animated_sprite_2d.hurt_animation_finished
	
	animated_sprite_2d.play_idle_animation()
	hurt_box_collision.call_deferred("set_disabled", false)
	is_hurting = false
