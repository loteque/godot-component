@tool
extends Node
    
func add_signals(component: Node):
    for sig in component.get_signal_list():
        if ComponentResource.get_autoload("Components") == null: 
            push_warning("Component Autoload not active") 
            return
        
        if has_signal(sig.name): 
            continue

        add_user_signal(sig.name, sig.args)
        push_warning("Added Signal " + sig.name)

func _init():
    if ComponentResource.get_autoload("Components") == null: 
        push_warning("Components Autoload added")
    else:
        push_warning("Components Autoload removed")