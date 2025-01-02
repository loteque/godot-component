@tool
extends Node
class_name TestSuite

@export var run_suite_: bool:
    set(b):
        run_suite(true)
        run_suite_ = false

var tests: Array[Test]

func run_suite(editor: bool = false) -> void:
    if editor: add_tests_by_child_nodes();
    for i in tests.size():
        var t = tests.pop_front()
        t.run_test()

func add_test(test: Test) -> void:
    tests.append(test)
    prints("Add Test:", test.name)

func clear_tests() -> void:
    tests.clear()

func add_tests_by_child_nodes():
    for child in get_children():
        if not (child as TestRunner): continue;
        add_test(child)