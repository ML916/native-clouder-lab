# Bad

- Terraform variables should be things that change between environments
- Too many variables can make the code hard to read and maintain

# Good

- Use hard coded values for things that do not change between different environments
- Limit the use of variables to things that impact cost, usually instance count / size
- Credentials and other similar sensitive information should never be hard coded