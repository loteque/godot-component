@tool
extends Node
class_name Tester

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

static func run_tests() -> void:

    for test in loaded:
        print_rich("[b]","TEST: ", test.test_path, "[/b]")
        test.run_assertions()
    

