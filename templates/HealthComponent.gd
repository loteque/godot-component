@tool
extends ComponentNode
class_name HealthComponent

@export var health: float:
    set(f):
        health = f
        health_changed.emit(health)

signal health_changed(health)