@tool
extends Node
class_name Test

@export var run_test: bool:
    set(b):
        Tester.load_test(self)
        Tester.run_tests()
        run_test = false
        Tester.unload_tests()

var module
var assertions: Array[Assertion]
var test_path: String = get_script().resource_path

class Assertion:
    enum Type{
        ASSERT_TRUE,
    }
    var name: StringName
    var method: Callable
    func assert_true(callable: Callable) -> Result:
            return Result.new(
                Assertion.Type.ASSERT_TRUE,
                callable.call()
            )
    func _init(method_: Callable, name_: String = "Anonymous") -> void:
        name = name_
        method = method_

class Result:
    var type: Assertion.Type
    var value: Variant
    var status: String
    func set_status():
        match type:
            Assertion.Type.ASSERT_TRUE:
                if value == true:
                    status = "succsess"
                else:
                    status = "failure" 
            _:
                "unsupported assertion type"
    func _init(type_: Assertion.Type, value_: Variant):
        type = type_
        value = value_
        set_status()

func print_result(assertion_name: StringName, result: Result) -> void:
    var rich_result: String
    if result.value:
        rich_result = (
            "[rainbow freq=0.2 sat=0.8 val=0.8][b]"
            +result.status
            +"[/b]"
        )
    else:
        rich_result = (
            "[shake rate=50.0 level=3 connected=0][color=orange_red][b]"
            +result.status
            +"[/b][/color][/shake]"
        )
    print_rich(result.type, " ", assertion_name, " ", result.value, " ", rich_result);

func run_assertions() -> void:
    for assertion in assertions:
        var result: Result = assertion.assert_true(assertion.method)
        reset_module()
        print_result(assertion.name, result)

func get_assertions() -> Array[Assertion]:
    var _assertions: Array[Assertion] 
    for property in get_property_list():
        if not property.class_name == "RefCounted": continue;
        var ref_counted = get(property.name)
        var is_type_assertion = ref_counted as Assertion
        if not is_type_assertion: continue;
        ref_counted.name = property.name
        _assertions.append(ref_counted)
    return _assertions

func reset_module():
    pass