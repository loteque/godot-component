@tool
extends Node
class_name Test

@export var run_test_: bool:
    set(b):
        TestRunner.load_test(self)
        TestRunner.run_tests()
        TestRunner.unload_tests()
        run_test_ = false

var module
var assertions: Array[Assertion]
var test_path: String = get_script().resource_path

class Result:
    
    enum Status{
        SUCCESS,
        FAILURE,
    }
    
    var type: Assertion.Type
    var value: Variant = false
    var status: Status = Status.FAILURE
    var message: String = "failure"
    
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
    
    func _init(type_: Assertion.Type, value_: Variant):
        type = type_
        value = value_
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
        return Result.new(Assertion.Type.ASSERT_TRUE, callable.call())
    
    func assert_false(callable: Callable) -> Result:
        return Result.new(Assertion.Type.ASSERT_FALSE, callable.call())
    
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

func run_assertion(assertion: Assertion, reset: bool = true) -> Result:
    var result = assertion.execute()
    if reset == false: return result;
    reset_module()
    return result

func run_assertions() -> void:
    for assertion in assertions:
        var result: Result = run_assertion(assertion)
        TestRunner.print_result(assertion.name, result)

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

func reset_module():
    pass

func init_module():
    pass