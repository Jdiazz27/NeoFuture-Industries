extends AnimatedSprite2D
class_name AnimationController

const MOVEMENT_TO_IDLE = {
	"back_walk": "back_idle",
	"front_walk": "front_idle",
	"right_walk": "right_idle"
}

const DIRECTION_TO_ATTACK_ANIMATION = {
	"back": "back_attack",
	"front": "front_attack",
	"right": "right_attack",
	"left": "left_attack"
}

const DIRECTION_TO_ATTACK_VECTOR = {
	"back": Vector2(0, -1),
	"front": Vector2(0, 1),
	"right": Vector2(1, 0),
	"left": Vector2(-1, 0)
}

var attack_direction = null

func play_movement_animation(vel: Vector2) -> void:
	if abs(vel.x) > abs(vel.y):
		# Movimiento lateral
		flip_h = vel.x < 0  # Voltea si va a la izquierda
		play("right_walk")
	else:
		# Movimiento vertical
		flip_h = false  # Asegura que no quede volteado
		if vel.y > 0:
			play("front_walk")
		else:
			play("back_walk")

func play_idle_animation():
	var idle_anim = MOVEMENT_TO_IDLE.get(animation, "")
	if idle_anim != "":
		play(idle_anim)


func play_attack_animation():
	var direction = animation.split("_")[0]
	attack_direction = direction
	play(DIRECTION_TO_ATTACK_ANIMATION[direction])


func _on_animation_finished() -> void:
	if DIRECTION_TO_ATTACK_ANIMATION.values().has(animation):
		var animation_string = String(animation)
		var direction = DIRECTION_TO_ATTACK_ANIMATION.find_key(animation_string)
		
		play(direction + "_idle")
		attack_direction = null
