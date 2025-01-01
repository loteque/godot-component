extends Resource
class_name GString

static func bbc_bold_string(string: String) -> String:
    return "[b]"+string+"[/b]"

static func bbc_color_string(string: String, bbc_color: String) -> String:
    return "[color="+bbc_color+"]"+string+"[/color]"

static func bbc_success_fail_string(success: bool, result_string: String, 
success_color: String, fail_color: String) -> String:
    if success:
        return bbc_color_string(bbc_bold_string(result_string), success_color)
    return bbc_color_string(bbc_bold_string(result_string), fail_color)
