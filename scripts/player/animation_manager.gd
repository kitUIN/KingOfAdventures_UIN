class_name AnimationManager
extends RefCounted

# 使用外部枚举定义（避免重复定义）

# 动画组件引用
var body_anim: AnimatedSprite2D
var hair_anim: AnimatedSprite2D
var eye_anim: AnimatedSprite2D
var hat_anim: AnimatedSprite2D
var clothing_anim: AnimatedSprite2D
var left_weapon_anim: AnimatedSprite2D
var right_weapon_anim: AnimatedSprite2D
var dual_weapon_anim: AnimatedSprite2D

var current_weapon_mode: int

func _init(body: AnimatedSprite2D, weapon_mode: int):
	body_anim = body
	current_weapon_mode = weapon_mode

# 设置附件动画引用
func set_hair_animation(anim: AnimatedSprite2D) -> void:
	hair_anim = anim

func set_eye_animation(anim: AnimatedSprite2D) -> void:
	eye_anim = anim

func set_hat_animation(anim: AnimatedSprite2D) -> void:
	hat_anim = anim

func set_clothing_animation(anim: AnimatedSprite2D) -> void:
	clothing_anim = anim

func set_weapon_animations(left: AnimatedSprite2D, right: AnimatedSprite2D, dual: AnimatedSprite2D) -> void:
	left_weapon_anim = left
	right_weapon_anim = right
	dual_weapon_anim = dual

func set_weapon_mode(mode: int) -> void:
	current_weapon_mode = mode

# 统一设置动画（包括身体、头发、眼睛和武器）
func set_animation(animation_name: String, should_play: bool = true) -> void:
	# 设置身体动画
	body_anim.animation = animation_name
	if should_play:
		body_anim.play()
	
	# 同步所有附件动画
	sync_all_animations()

# 统一设置翻转（包括身体、头发、眼睛、帽子和衣服和武器）
func set_flip(should_flip: bool) -> void:
	body_anim.flip_h = should_flip
	if hair_anim != null:
		hair_anim.flip_h = should_flip
	if eye_anim != null:
		eye_anim.flip_h = should_flip
	if hat_anim != null:
		hat_anim.flip_h = should_flip
	if clothing_anim != null:
		clothing_anim.flip_h = should_flip
	sync_weapon_flip(should_flip)

# 播放攻击动画
func play_attack_animation(attack_type: int) -> void:
	var attack_anim = "attack_" + str(attack_type)
	if current_weapon_mode == 1:  # DUAL_HAND = 1
		attack_anim += "_d"
	else:
		attack_anim += "_s"
	
	set_animation(attack_anim)

# 播放移动动画
func play_movement_animation(is_on_floor: bool, input_dir: float) -> void:
	var animation: String = "default"
	if not is_on_floor:
		animation = "jump"
	elif input_dir != 0:
		animation = "run"
	
	# 根据武器模式选择动画后缀
	if current_weapon_mode == 1:  # DUAL_HAND = 1
		animation = animation + "_d"
	else:
		animation = animation + "_s"
	
	set_animation(animation)

# 同步所有附件动画（头发、眼睛、帽子、衣服和武器）
func sync_all_animations() -> void:
	sync_hair_animation()
	sync_eye_animation()
	sync_hat_animation()
	sync_clothing_animation()
	sync_weapon_animations()

# 同步头发动画
func sync_hair_animation() -> void:
	if hair_anim == null:
		return
	
	# 同步动画
	hair_anim.animation = body_anim.animation
	hair_anim.flip_h = body_anim.flip_h
	
	# 如果身体动画正在播放，让头发也播放
	if body_anim.is_playing():
		hair_anim.play()
	else:
		hair_anim.stop()

# 同步眼睛动画
func sync_eye_animation() -> void:
	if eye_anim == null:
		return
	
	# 同步动画
	eye_anim.animation = body_anim.animation
	eye_anim.flip_h = body_anim.flip_h
	
	# 如果身体动画正在播放，让眼睛也播放
	if body_anim.is_playing():
		eye_anim.play()
	else:
		eye_anim.stop()
# 同步帽子动画
func sync_hat_animation() -> void:
	if hat_anim == null:
		return
	
	# 同步动画
	hat_anim.animation = body_anim.animation
	hat_anim.flip_h = body_anim.flip_h
	
	# 如果身体动画正在播放，让帽子也播放
	if body_anim.is_playing():
		hat_anim.play()
	else:
		hat_anim.stop()

# 同步衣服动画
func sync_clothing_animation() -> void:
	if clothing_anim == null:
		return
	
	# 同步动画
	clothing_anim.animation = body_anim.animation
	clothing_anim.flip_h = body_anim.flip_h
	
	# 如果身体动画正在播放，让衣服也播放
	if body_anim.is_playing():
		clothing_anim.play()
	else:
		clothing_anim.stop()

# 同步所有武器动画
func sync_weapon_animations() -> void:
	if current_weapon_mode == 0:  # SINGLE_HAND = 0
		sync_single_weapon_animation(left_weapon_anim)
		sync_single_weapon_animation(right_weapon_anim)
	else:
		sync_single_weapon_animation(dual_weapon_anim)

# 同步单个武器动画
func sync_single_weapon_animation(weapon_anim: AnimatedSprite2D) -> void:
	if weapon_anim == null:
		return
	
	# 同步动画
	weapon_anim.animation = body_anim.animation
	weapon_anim.flip_h = body_anim.flip_h
	
	# 如果身体动画正在播放，让武器也播放
	if body_anim.is_playing():
		weapon_anim.play()
	else:
		weapon_anim.stop()

# 同步武器翻转
func sync_weapon_flip(should_flip: bool) -> void:
	if current_weapon_mode == 0:  # SINGLE_HAND = 0
		if left_weapon_anim != null:
			left_weapon_anim.flip_h = should_flip
		if right_weapon_anim != null:
			right_weapon_anim.flip_h = should_flip
	else:
		if dual_weapon_anim != null:
			dual_weapon_anim.flip_h = should_flip
