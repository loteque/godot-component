@tool
extends Node
class_name TestRunner

@export var run_tests_: bool:
    set(b):
        load_tests(self)
        run_tests()
        run_tests_ = false
        unload_tests()

static var loaded: Array[Node]

static func load_test(test: Test):
    var instance = test.get_script().new()
    loaded.append(instance)

static func load_tests(tester_node: Node):
    for child in tester_node.get_children():
        load_test(child)

static func unload_tests():
    loaded.clear()

static func run_test(test: Test) -> void:
    print_rich(GString.bbc_bold_string(test.test_path))
    test.init_module()
    test.run_assertions()

static func run_tests() -> void:
    for test in loaded:
        run_test(test)
    
static func print_result(assertion_name: StringName, result: Test.Result) -> void:
    var success: bool
    match result.status:
        Test.Result.Status.SUCCESS:
            success = true
        Test.Result.Status.FAILURE:
            success = false
    var rich_result = GString.bbc_success_fail_string(success, result.message, "lime_green", "orange_red")
    print_rich(result.type, " ", assertion_name, " ", result.value, " ", rich_result);
