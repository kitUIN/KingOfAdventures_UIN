extends CharacterBody2D

@export var gravity: float = 1200.0
@export var jump_force: float = -400.0
@export var speed: float = 100.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 水平移动
	var input_dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * speed

	# 重力
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_force

	move_and_slide()

	# --------------------
	# 动画控制
	# --------------------
	if not is_on_floor():
		anim.animation = "jump_d"
	elif input_dir != 0:
		anim.animation = "run"
	else:
		anim.animation = "default"
	if input_dir != 0:
		anim.flip_h = input_dir < 0
		
	# 根据方向翻转
	anim.play()


func _ready() -> void:
	hide()
	
func init(start_pos: Vector2) -> void:
	position = start_pos
	show()
