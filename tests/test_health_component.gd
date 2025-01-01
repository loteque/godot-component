@tool
extends Test

func _init() -> void:
    assertions.append_array(get_assertions())
    module = load("res://templates/HealthComponent.gd").new() as HealthComponent

func reset_module():
    module.revivable = true
    module.healable = true
    module.invincible = false
    module.max_health = 100
    module.health = module.max_health

var init_health_is_max_health := Assertion.new(
    func(): 
        return module.health == module.max_health
)

var can_set_module_property := Assertion.new(
    func():
        reset_module()
        module.health = 50
        return module.health == 50
)

var test_resets_module := Assertion.new(
    func():
        return module.health == module.max_health
)

var can_set_not_healable := Assertion.new(
    func():
        module.healable = false
        var health_before = module.health
        var health_reduced = health_before / 2
        module.health = health_reduced
        module.health = module.max_health
        var health_after_heal_attempt = module.health
        return health_after_heal_attempt <= health_reduced
)

var can_set_healable := Assertion.new(
    func():
        module.healable = true
        module.revivable = true
        module.health = module.max_health
        module.revivable = false
        module.health = module.max_health / 2
        module.health = module.max_health 
        return module.health == module.max_health
)

var can_set_not_revivable := Assertion.new(
    func():
        module.revivable = false
        module.health = 0
        module.health = module.max_health
        return module.health == 0
)

var can_set_revivable := Assertion.new(
    func():
        module.revivable = true
        module.healable = true
        module.health = 0
        module.health = module.max_health
        return module.health > 0
)

var can_set_invincible := Assertion.new(
    func():
        module.invincible = true
        module.health -= 50
        return module.health == module.max_health
)

var can_set_not_invincible := Assertion.new(
    func():
        module.invincible = true
        module.invincible = false
        var health_before = module.health
        module.health -= 50
        return module.health <= health_before - 50
)

var set_health_to_max := Assertion.new(
    func():
        module.health = 50
        var was_health_less_than_max = module.health < module.max_health
        module.health = module.max_health
        var does_health_eq_max_health = module.health == module.max_health
        return was_health_less_than_max and does_health_eq_max_health
)
