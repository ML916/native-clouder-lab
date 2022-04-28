# Anti DRY terraform

## Pros

- easy to test and change things without affecting all environments

## Cons

- Environments are no longer identical
- Deploying in one environment gives no guarantee that it will work in another
- {n} copies of the same code to maintain
- Very easy to miss small details such as naming of resources
- Over time each instance will naturally drift from the others