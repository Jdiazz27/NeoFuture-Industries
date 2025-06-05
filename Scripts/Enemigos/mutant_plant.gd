extends Node2D

@export var hp: int = 100
@export var damage = 5

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $attack_timer
@onready var player = null
@onready var hit_box_collision: CollisionShape2D = $HitBox/hitBoxCollision
@onready var hurt_box_collision: CollisionShape2D = $hurtBox/hurtBoxCollision

var is_attacking: bool = false
var takind_dmg: = false

func _ready() -> void:
	hit_box_collision.disabled = true

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()

func take_damage(dmg):
	takind_dmg = true
	hurt_box_collision.call_deferred("set_disabled", true)
	hp -= dmg
	print("A la planta se le restó ", dmg, " puntos de vida")
	animated_sprite_2d.play("hit")
	await animated_sprite_2d.animation_finished
	takind_dmg = false
	hurt_box_collision.call_deferred("set_disabled", false)
	animated_sprite_2d.play("idle")

func start_attack():
	if not is_attacking or player == null or takind_dmg:
		return

	var to_player = player.global_position - global_position
	
	hit_box_collision.call_deferred("set_disabled", false)
	if to_player.x > 0:
		animated_sprite_2d.play("attack_right")
		animation_player.play("attack_right")
	else:
		animated_sprite_2d.play("attack_left")
		animation_player.play("attack_left")

	await animated_sprite_2d.animation_finished
	hit_box_collision.call_deferred("set_disabled", true)
	animated_sprite_2d.play("idle")

func die():
	attack_timer.stop()
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		is_attacking = true
		attack_timer.start()

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == player:
		is_attacking = false
		attack_timer.stop()
		player = null

func _on_attack_timer_timeout():
	start_attack()
