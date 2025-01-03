extends Node2D

@onready var hit_box: HitBoxComponent2D = get_node("HitBoxComponent2D")

func _physics_process(_delta: float) -> void:
    hit_box.one_shot()
