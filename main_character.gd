extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
const FLY_SPEED = 500.0

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var gravity_direction: float = 1.0
var can_double_jump: bool = false
var is_flying: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F:
			is_flying = !is_flying
			velocity.y = 0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	if is_flying:
		var fly_dir := Input.get_axis("ui_up", "ui_down")
		if Input.is_key_pressed(KEY_W):
			fly_dir = -1.0
		elif Input.is_key_pressed(KEY_S):
			fly_dir = 1.0
		velocity.y = fly_dir * FLY_SPEED
		sprite_2d.animation = "Jumping"
	else:
		if is_on_floor():
			can_double_jump = true
		else:
			velocity += get_gravity() * gravity_direction * delta
			sprite_2d.animation = "Jumping"

		if Input.is_action_just_pressed("Jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY * gravity_direction
			elif can_double_jump:
				flip_gravity()

		if is_on_floor():
			if abs(velocity.x) > 1:
				sprite_2d.animation = "Running"
			else:
				sprite_2d.animation = "Idle"

	move_and_slide()

	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0

func flip_gravity() -> void:
	can_double_jump = false
	gravity_direction *= -1.0
	up_direction = Vector2(0, -1 * gravity_direction)
	sprite_2d.flip_v = (gravity_direction < 0)
	velocity.y = 200.0 * gravity_direction

func _on_hazard_detect_body_entered(_body: Node2D) -> void:
	if not is_flying:
		get_tree().current_scene.get_node("GameOver").show_game_over()

func _on_win_detect_body_entered(_body: Node2D) -> void:
	get_tree().current_scene.get_node("WinScreen").show_win_screen()
