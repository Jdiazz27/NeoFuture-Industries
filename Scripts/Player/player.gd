extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $Inventory
@onready var on_screen_ui: OnScreenUI = $OnScreenUI
@onready var combat_system: CombatSystem = $CombatSystem

@export var health = 100




const SPEED = 5000.0

func _physics_process(delta: float) -> void:
	
	if animated_sprite_2d.animation.contains("attack"):
		return
	
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

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
		inventory.add_item(area.inventory_item, area.stacks)
		area.queue_free()
		


func on_damage_taken(damage: int) -> void:
	on_screen_ui.apply_damage_to_health_bar(damage)
	
	
func on_player_dead():
	set_physics_process(false)
	combat_system.set_process_input(false)
	animated_sprite_2d.play("dead")
	
func setup_test_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://Resources/Weapons/Sword/sword_inventory_item.tres")
	
	inventory.add_item(SWORD_INVENTORY_ITEM, 1)
