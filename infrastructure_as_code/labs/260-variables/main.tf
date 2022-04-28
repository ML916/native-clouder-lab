variable "something-with-default" {
    default = "something"
}

variable "something-without-default" {

}

variable "foobar" {

}

output "one" {
    value = var.something-with-default
}

output "two" {
    value = var.something-without-default
}

output "four" {
    value = var.foobar
}