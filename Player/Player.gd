extends KinematicBody2D

export var MOVE_SPEED: float = 200.0

var velocity: Vector2 = Vector2.ZERO
var is_jumping: bool
var input_vector: Vector2

var HEALTH
export(int) var JUMP_HEIGHT_INDICATOR  = 6
export(float) var JUMP_TIME_TO_PEAK
export(float) var JUMP_TIME_TO_DESCENT

var JUMP_HEIGHT: float = JUMP_HEIGHT_INDICATOR * (258/6)

onready var JUMP_VELOCITY: float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
onready var JUMP_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
onready var FALL_GRAVITY: float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0

enum STATE {
	IDLE,
	RUN,
	JUMP,
	FALL,
	BEFORE_JUMP,
	ATTACK,
	HURT
}

var state_memory = []

var current_state

func _ready() -> void:
	current_state = STATE.IDLE
	$CPUParticles2D.emitting = false
	HEALTH = Data.Player_Health

func _physics_process(delta):
	input_vector = get_input_vector()
	
	if input_vector.x > 0:
		$Sprite.flip_h = false
		# TODO : Smooth camera lookahead
		#$Camera2D.offset_h = .5
		$CPUParticles2D.rotation_degrees = 90
		$CPUParticles2D.position = Vector2(-15, 26)
	elif input_vector.x < 0:
		$Sprite.flip_h = true
		#$Camera2D.offset_h = -.5
		$CPUParticles2D.rotation_degrees = -90
		$CPUParticles2D.position = Vector2(15, 26)
	
	
	
	match current_state:
		STATE.IDLE:
			apply_fall_gravity(delta)
			$AnimationPlayer.play("Idle")
			$CPUParticles2D.emitting = false
			#$CPUParticles2D.hide()

			if Input.is_action_just_pressed("jump"):
				state_memory.push_back(STATE.IDLE)
				current_state = STATE.JUMP
				continue
			
			if velocity.y > 0  and !is_on_floor():
				$CoyoteTimer.start()
				state_memory.push_back(STATE.IDLE)
				current_state = STATE.FALL
				continue
			
			if abs(input_vector.x) > 0:
				current_state = STATE.RUN
		
		STATE.RUN:
			apply_fall_gravity(delta)
			$AnimationPlayer.play("Run")
			$CPUParticles2D.emitting = true
			#$CPUParticles2D.show()
			
			move_player_in_x()
			
			if Input.is_action_just_pressed("jump"):
				state_memory.push_back(STATE.RUN)
				current_state = STATE.JUMP
				continue
			
			if velocity.y > 0 and !is_on_floor():
				$CoyoteTimer.start()
				state_memory.push_back(STATE.RUN)
				current_state = STATE.FALL
				continue
			
			if abs(input_vector.x) < 0.1:
				current_state = STATE.IDLE
		
		STATE.JUMP:
			apply_fall_gravity(delta)
			$CPUParticles2D.emitting = false
			#$CPUParticles2D.hide()
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
			
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y = 0
			
			move_player_in_x()
			
			$AnimationPlayer.play("Jump_Up")
			
			if velocity.y > 0:
				current_state = STATE.FALL
			
			# Transition from BEFORE_JUMP to JUMP handled in "_on_AnimatedSprite_animation_finished()" method
		
		STATE.FALL:
			apply_fall_gravity(delta)
			$CPUParticles2D.emitting = false
			$AnimationPlayer.play("Jump_Down")
			velocity.x = input_vector.x * MOVE_SPEED
			
			if Input.is_action_just_pressed("jump") and !$CoyoteTimer.is_stopped():
				$CoyoteTimer.stop()
				current_state = STATE.JUMP
				velocity.y = JUMP_VELOCITY
				continue
			
			if is_on_floor():
				current_state = state_memory.pop_back()
		
		STATE.HURT:
			HEALTH -= 1
			$Hurt_Area/CollisionShape2D.disabled = true
			$"Flash Timer".start()
			$Sprite.material.set_shader_param("flashModifier", 1)
			velocity = Vector2.ZERO
			velocity += Vector2(0, -600)
#			var tween = get_node("Hurt Tween")
#			tween.interpolate_property(self, "position",position, position + Vector2(100, -100), 0.1,Tween.TRANS_LINEAR, Tween.EASE_OUT)
#			tween.start()
			current_state = state_memory.pop_back()
	
	velocity = move_and_slide(velocity, Vector2.UP)


#func _process(_delta: float) -> void:
#	if HEALTH > 0:
#		$"../CanvasLayer/UI/Full Heart".show()
#		$"../CanvasLayer/UI/Full Heart".rect_size.x = 16 * HEALTH
#	else:
#		$"../CanvasLayer/UI/Full Heart".hide()
#
#	$"../CanvasLayer/UI/Jump Height/Jump Height Indicator".rect_size.x = (90/6) * (JUMP_HEIGHT/258) * JUMP_HEIGHT_INDICATOR

func jump():
	velocity.y = JUMP_VELOCITY

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY

func move_player_in_x() -> void:
	velocity.x = input_vector.x * MOVE_SPEED

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

func apply_fall_gravity(delta: float) -> void:
	velocity.y += get_gravity() * delta

func _on_Flash_Timer_timeout():
	$Sprite.material.set_shader_param("flashModifier", 0)
	$Hurt_Area/CollisionShape2D.disabled = false

func _on_Hurt_Area_area_entered(_area: Area2D) -> void:
	state_memory.push_back(current_state)
	current_state = STATE.HURT
