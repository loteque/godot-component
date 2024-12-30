@tool
extends ComponentNode
class_name HealthComponent

@export var resource = ComponentResource.new(self):
    set(r):
        resource = r
        resource.component = self

signal health_changed(health, sender: HealthComponent)