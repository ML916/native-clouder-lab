locals {
    foo = join("", ["f", "o", "o"])
    bar = 100 + (2 * 10) + 3
    world = "world"
}

output "foo" {
    value = "Foo is [${local.foo}]"
}

output "bar" {
    value = "Bar is [${local.bar}]"
}

output "hello" {
    value = format("Hello %s!", local.world)
}

output "case" {
    value = join("", [
        "lower: ", lower("ABCD"),
            " | ",
        "upper: ", upper("abcd"),
    ])
}

output "split" {
    value = split(",", "foo,bar,baz")
}
