@tool
extends Test
class_name TestRunner

@export var run_test_: bool:
    set(b):
        run_test()
        run_test_ = false

var result: Array[Result]

func init_test() -> Test:
    var script: Script = get_script()
    return script.new()

func run_test() -> void:
    var test = init_test()
    test.setup()
    test.setup_module()
    print_rich(GString.bbc_bold_string(test.test_path))
    for assertion in test.assertions:
        result.append(assertion.execute())
        test.reset_module()
    print_result()
    test.reset()
    result.clear()

func print_result() -> void:
    for r in result: 
        var success: bool
        match r.status: 
            Test.Result.Status.SUCCESS:
                success = true
            Test.Result.Status.FAILURE:
                success = false
        var rich_result = GString.bbc_success_fail_string(success, r.message, "lime_green", "orange_red")
        print_rich(r.type, " ", r.assertion_name, " ", r.value, " ", rich_result);