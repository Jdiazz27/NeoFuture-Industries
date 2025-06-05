extends AnimatedSprite2D
class_name AnimationController

@onready var weapon: Node2D = $"../weapon"
@onready var weapon_fist_child = weapon.get_child(0)
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
signal attack_animation_finished
signal hurt_animation_finished
var attack_direction = null
var last_direction: Vector2 = Vector2.DOWN

const MOVEMENT_TO_IDLE = {
	"up_walk": "up_idle",
	"down_walk": "down_idle",
	"right_walk": "right_idle",
	"left_walk": "left_idle"
}

const DIRECTION_TO_ATTACK_ANIMATION = {
	"up": "up_attack",
	"down": "down_attack",
	"right": "right_attack",
	"left": "left_attack"
}

func _ready():
	self.connect("frame_changed", Callable(self, "_on_frame_changed"))

func _on_frame_changed():
	if frame == sprite_frames.get_frame_count(animation) - 1:
		if DIRECTION_TO_ATTACK_ANIMATION.values().has(animation):
			emit_signal("attack_animation_finished")
		elif animation.begins_with("hurt"):
			emit_signal("hurt_animation_finished")

func play_movement_animation(vel: Vector2) -> void:
	if vel.length() > 0:
		last_direction = vel.normalized()

	if abs(vel.x) > abs(vel.y):
		if vel.x < 0:
			play("left_walk")
		else:
			play("right_walk")
	else:
		if vel.y > 0:
			play("down_walk")
		else:
			play("up_walk")

func play_idle_animation():
	var idle_anim = MOVEMENT_TO_IDLE.get(animation, "")
	if idle_anim != "":
		play(idle_anim)

func play_attack_animation(velocity):
	var direction = ""
	if velocity.length() == 0:
		velocity = last_direction

	if abs(velocity.x) > abs(velocity.y):
		direction = "right" if velocity.x > 0 else "left"
	else:
		direction = "down" if velocity.y > 0 else "up"

	weapon_fist_child.enable_hitbox()
	play(DIRECTION_TO_ATTACK_ANIMATION[direction])
	animation_player.play(DIRECTION_TO_ATTACK_ANIMATION[direction] + "_weapon")
	await animation_player.animation_finished
	weapon_fist_child.disable_hitbox()

func play_hurt_animation(velocity: Vector2):
	var anim = ""
	if abs(velocity.x) > 0:
		anim = "hurt_right" if velocity.x > 0 else "hurt_left"
	else:
		anim = "hurt_right"

	play(anim)
	animation_player.play(anim)
	await animation_player.animation_finished
	play_idle_animation()
	emit_signal("hurt_animation_finished")

func _on_animation_finished() -> void:
	if DIRECTION_TO_ATTACK_ANIMATION.values().has(animation):
		var animation_string = String(animation)
		var direction = DIRECTION_TO_ATTACK_ANIMATION.find_key(animation_string)
		
		play(direction + "_idle")
		attack_direction = null
