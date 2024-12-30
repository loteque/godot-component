@tool
extends Resource
class_name ComponentResource 

var component: Node
var components_singleton = func():
    if get_autoload("Components") != null: 
        return get_autoload("Components") 
    else:
         return null 

@export var make_signals_global: bool = false:
    set(b):
        if get_autoload("Components") == null:
            make_signals_global = false
        else:
            get_autoload("Components").add_signals(component)
            make_signals_global = b


static func get_autoload(node_path: NodePath) -> Variant:
    
    if !Engine.get_main_loop().root.has_node(node_path):
        push_error(node_path, ' Autoload is not set')
        return null
        
    return Engine.get_main_loop().root.get_node(node_path)

func _init(component_node: Node):
    component = component_node
    if make_signals_global: 
        components_singleton.add_signals(component)