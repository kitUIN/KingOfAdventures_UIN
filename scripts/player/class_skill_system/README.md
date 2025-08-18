# 职业与技能系统

这个文件夹包含了游戏中完整的职业和技能系统实现。

## 📁 文件结构

### 核心系统文件
- **`player_class.gd`** - 职业系统核心
  - 定义战士和法师两个职业
  - 管理职业属性加成
  - 提供职业切换功能

- **`skill_system.gd`** - 技能系统核心
  - 管理技能冷却时间和持续时间
  - 处理技能激活和结束逻辑
  - 支持被动和主动技能

### 技能管理器
- **`passive_skill_manager.gd`** - 被动技能管理器
  - 奔跑技能（双击前进键奔跑）
  - 冲刺攻击技能（奔跑中攻击）
  - 二段跳技能

- **`active_skill_manager.gd`** - 主动技能管理器
  - 战士技能：冲锋斩击、盾牌格挡、狂暴、战吼
  - 法师技能：火球术、冰冻术、治疗术、传送术

### 工具和演示
- **`skill_demo.gd`** - 技能系统演示和测试工具
  - 提供技能测试函数
  - 系统状态监控
  - 使用示例代码

## 🔗 依赖关系

```
player.gd (主控制器)
├── player_class.gd (职业系统)
├── skill_system.gd (技能核心)
├── passive_skill_manager.gd (被动技能)
└── active_skill_manager.gd (主动技能)
```

## 🎯 使用方式

在主玩家脚本中引用这些类：

```gdscript
# 职业和技能系统类
const PlayerClassClass = preload("res://scripts/player/class_skill_system/player_class.gd")
const SkillSystemClass = preload("res://scripts/player/class_skill_system/skill_system.gd")
const PassiveSkillManagerClass = preload("res://scripts/player/class_skill_system/passive_skill_manager.gd")
const ActiveSkillManagerClass = preload("res://scripts/player/class_skill_system/active_skill_manager.gd")
```

## 🚀 快速开始

1. 职业设置：
```gdscript
player.set_player_class(0)  # 设置为战士
player.set_player_class(1)  # 设置为法师
```

2. 技能控制：
```gdscript
# 启用被动技能
player.set_passive_skill(0, true)  # 启用奔跑
player.set_passive_skill(1, true)  # 启用冲刺攻击
player.set_passive_skill(2, true)  # 启用二段跳
```

3. 技能测试：
```gdscript
var demo = preload("res://scripts/player/class_skill_system/skill_demo.gd").new()
demo.demo_usage(player)
```

## ⚙️ 配置参数

所有技能参数都可以在对应的管理器文件中调整：
- 冷却时间
- 持续时间
- 伤害倍数
- 速度倍数
- 其他效果参数

## 🔧 扩展指南

要添加新的职业或技能：
1. 在 `player_class.gd` 中添加新职业类型
2. 在 `skill_system.gd` 中定义新技能ID
3. 在相应的管理器中实现技能逻辑
4. 更新技能名称映射

---

**注意**：此系统设计为模块化架构，便于维护和扩展。所有文件都有详细的注释和文档说明。
