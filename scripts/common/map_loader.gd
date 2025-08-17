extends Node2D

@export var ground_1_scene: PackedScene
@export var dirt_1_scene: PackedScene

# 可调参数
@export var view_width: int = 1080
@export var segment_width: int = 90
@export var grass_height: int = 30
@export var dirt_height: int = 58

@export var base_grass_y: int = 640      # 草皮顶面的基线 y（最低起始高度）
@export var max_step_per_column: int = 14 # 单列高度变化上限（像素）
@export var max_amplitude: int = 120      # 相对基线的最大起伏（像素）
@export var plateau_chance: float = 0.45  # 保持同高的概率（形成台阶）
@export var raise_chance: float = 0.28    # 上升概率（其余为下降概率）
@export var plateau_run_min: int = 1      # 最小台阶连续列数
@export var plateau_run_max: int = 8      # 最大台阶连续列数

func init() -> void:
	var columns: int = int(ceil(float(view_width) / float(segment_width))) + 2

	var current_y: float = base_grass_y
	var min_y: float = base_grass_y - float(max_amplitude)
	var max_y: float = base_grass_y + float(max_amplitude)

	var plateau_left: int = 0

	for i in range(columns):
		var x: float = float(i * segment_width)

		if plateau_left > 0:
			plateau_left -= 1
		else:
			var r := randf()
			if r < plateau_chance:
				plateau_left = randi_range(plateau_run_min, plateau_run_max) - 1
			else:
				var sign := 1 if randf() < raise_chance else -1
				var step := 58 * sign    # 固定台阶高度差
				current_y = clamp(current_y + step, min_y, max_y)

		# 实例化草皮
		_instance_scene("ground_1", x, current_y)
		# 泥土紧跟草皮下方
		_instance_scene("dirt_1", x, current_y + grass_height)



func _instance_scene(scene_name: String, x: float, y: float) -> void:
	var instance: Node2D
	match scene_name:
		"ground_1":
			instance = ground_1_scene.instantiate()
		"dirt_1":
			instance = dirt_1_scene.instantiate()
		_:
			return

	instance.position = Vector2(x, y)
	print(x,' ' , y)
	add_child(instance)

func _ready() -> void:
	show()
