extends KinematicBody2D


export(int) var BASE_SPEED = 100
export(int) var movement_range = 500

var velocity = Vector2.ZERO
var direction = 1

export(float) var HEALTH = 36.0
export(int) var JUMP_HEIGHT_INDICATOR  = 1
export(float) var JUMP_TIME_TO_PEAK = .1
export(float) var JUMP_TIME_TO_DESCENT

var JUMP_HEIGHT: float = JUMP_HEIGHT_INDICATOR * (258/6)

onready var JUMP_VELOCITY: float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
onready var JUMP_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
onready var FALL_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$Timer.start()
	$Sprite.material.set_shader_param("flashModifier", 0)
	$AnimationPlayer.play("Run")
	$RichTextLabel.text = str(HEALTH)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		apply_fall_gravity(delta)
	
	if $"Flip Cast".is_colliding():
		_on_Timer_timeout()
	elif $"Jump Cast".is_colliding()  and $"On Ground Cast".is_colliding():
		velocity.y = JUMP_VELOCITY
	
	velocity.x = direction * BASE_SPEED * Data.difficulty
	velocity = move_and_slide(velocity)

func apply_fall_gravity(delta: float) -> void:
	velocity.y += get_gravity() * delta

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY


func _on_Timer_timeout() -> void:
	direction *= -1
	$Sprite.flip_h = not $Sprite.flip_h
	$"Jump Cast".rotate(deg2rad(180))
	$"Flip Cast".rotate(deg2rad(180))
	rng.randomize()
	$Timer.start(rng.randi()%10)


func _on_Hurt_Area_area_entered(_area: Area2D) -> void:
	HEALTH = HEALTH * (Data.difficulty / 6)
	HEALTH -= 1
	if HEALTH <= 0:
		self.queue_free()
		return
	$Sprite.material.set_shader_param("flashModifier", 1)
	$"Flash Timer".start()
	$RichTextLabel.text = str(HEALTH)
	print(HEALTH)


func _on_Flash_Timer_timeout() -> void:
	$Sprite.material.set_shader_param("flashModifier", 0)
