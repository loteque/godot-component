@tool
extends Node
class_name Test

var module
var assertions: Array[Assertion]
var test_path: String = get_script().resource_path

class Result:
    
    enum Status{
        SUCCESS,
        FAILURE,
    }
    
    var assertion_name: StringName
    var type: Assertion.Type
    var value: Variant = false
    var status: Status = Status.FAILURE
    var message: String = "failure"

    func to_dict():
        return {
        "assertion_name": assertion_name, 
        "type": type,
        "value": value,
        "status": status,
        "message": message,
        }
    
    func set_status_assert_true():
        if value == false: return;
        status = Status.SUCCESS
        message = "success"
    
    func set_status_assert_false():
        if value == true: return;
        status = Status.SUCCESS 
        message = "success"
    
    func set_status():
        match type:
            Assertion.Type.ASSERT_TRUE:
                set_status_assert_true()
            Assertion.Type.ASSERT_FALSE:
                set_status_assert_false()
            _:
                push_error("Unsupported Assertion Type")
    
    func _init(assertion_name_: StringName, type_: Assertion.Type, value_: Variant):
        type = type_
        value = value_
        assertion_name = assertion_name_
        set_status()

class Assertion:
    
    enum Type{
        ASSERT_TRUE,
        ASSERT_FALSE,
    }
    
    var method: Callable
    var type: Type
    var name: StringName = &"Anonymous"
    
    func update_name(name_: StringName):
        name = name_
    
    func assert_true(callable: Callable) -> Result:
        return Result.new(name, Assertion.Type.ASSERT_TRUE, callable.call())
    
    func assert_false(callable: Callable) -> Result:
        return Result.new(name, Assertion.Type.ASSERT_FALSE, callable.call())
    
    func execute() -> Result:
        match type:
            Type.ASSERT_TRUE:
                return assert_true(method)
            Type.ASSERT_FALSE:
                return assert_false(method)
            _:
                push_error("Unsupported Assertion Type")
                return
    
    func _init(method_: Callable, type_: Type = Type.ASSERT_TRUE) -> void:
        method = method_
        type = type_

func get_assertions() -> Array[Assertion]:
    var _assertions: Array[Assertion] 
    for property in get_property_list():
        if not property.class_name == "RefCounted": continue;
        var ref_counted = get(property.name)
        var is_type_assertion = ref_counted as Assertion
        if not is_type_assertion: continue;
        ref_counted.update_name(property.name)
        _assertions.append(ref_counted)
    return _assertions

func reset():
    assertions.clear()

func setup() -> void:
    assertions = get_assertions()

func reset_module():
    pass

func setup_module():
    pass
