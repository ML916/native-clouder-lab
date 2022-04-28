resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "echo $FOO $BAR $BAZ >> /output/foo.txt"

    environment = {
      FOO = "bar"
      BAR = 1
      BAZ = "true"
    }
  }
}