# Secrets

This is a seemingly innocuous thing to do, but it has a number of drawbacks.

- State will contain sensitive information.
- State is usually stored in a bucket and not treated in the same way a secret manager is treated
- Almost certainly not encrypted
- Rotating secrets required doing a deployment which carries risk and is slow

[Terraform on sensitive state](https://www.terraform.io/language/state/sensitive-data#recommendations)