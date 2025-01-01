@tool
extends Test

func _init() -> void:
    assertions.append_array(get_assertions())
    module = null

var identify := Assertion.new(
    func(i := false):
        if self: i = true
        return i
)

var inside_tree := Assertion.new(
    func(i := false):
        if self.is_inside_tree(): i = true
        return i
)