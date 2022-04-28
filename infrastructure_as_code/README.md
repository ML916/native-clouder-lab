# ikealab - Infrastructure as Code

## Case Studies

- [Knight Capital](/case-studdies/knight-capital-group.md): When infrastructure is done manually, mistakes can happen.

## Note

The information in this lab is not exhaustive and aimed at general use cases and a good starting point. As with all projects, there are many variables to consider before committing to a solution.


## Business Case

Managing a complex infrastructure landscape such as what is found within IKEA can be a challenge. It's extremely vast and fast changing nature makes it impossible to fully comprehend.

Large infrastructure landscapes are near impossible to accurately document. Changes are made faster than documentation can be updated. There is a large risk of the documentation not matching reality, even when it is updated.

With the lack of understanding and context to every corner of the infrastructure, changes are inherently risky. Even if all the information was accurate and up to date, manual changes carry a high risk of human error leading to outages or bugs.

## Core Objectives for IaC

Below are a few key objectives that need to be reached. They can be reached in various ways, thought IaC is often able to achive these objectives with less effort.

- Simplify infrastructure change management flow by reusing the application change management process. \*
- Simplify (or remove) access management complexities to the environments. \*
- Have an automated process for infrastructure changes that is consistent and repeatable.
- Have an accurate, upto date document describing infrastructure.
- Ability to test and analyse infrastructure changes before deployment. Functionality, cost, security etc.


\* This is a legal requirement and is audited yearly. In addition to lower reliability of the product, poor practice can drive excessive costs. An example of this is higher security insurance premium due to perceived lack of control.
 
## Resources

- https://www.terraform.io/cloud-docs/guides/recommended-practices
- https://github.com/shuaibiyy/awesome-terraform#readme
- https://www.terraform-best-practices.com/

## Before IaC

- Manual
    - Error prone
    - Slow to adapt
    - Insecure due to limited resources for maintenance
- Ambiguity
    - No visibility on what is being changed
    - Changes are made without notification
- Handovers
    - Due to the massive risk, Operations refuse changes
    - A lot of wasted time for sync meetings

## After IaC

- Cost reduction
    - Tight control over what is running
    - Easy to remove unused infrastructure
    - Spin up / tear down with simple commands
- Speed
    - Quicker deployments
    - Automated processes
- Reduce Risk
    - Visibility on what will be changed
    - Relatively simple rollback
    - Transparency
- DevOps
    - No need to handover to operations
    - Anyone on a DevOps team can handle infrastructure

## Flavours

There are two main ways of doing IaC.

### Imperative

> [Imperative Programming] is a paradigm that uses statements that change a program's state. In much the same way that the imperative mood in natural languages expresses commands, an imperative program consists of commands for the computer to perform.

- Usually done with "normal" programming languages
- Contains a lot of (buggy) logic
- Requires unit testing, maintenance and documentation

See example in **lab 010-imperative**.

#### Pros

- Low learning curve
- Reuse existing tools / knowledge
- Can do practically anything

#### Cons

- Can do practically anything
- Spaghetti code
- Highly mutable
- Requires unit testing like application code

#### Examples

- bash
- python
- your-favourite-language
- [gcloud](https://cloud.google.com/sdk/gcloud)
- [pulumi](https://www.pulumi.com/)


Deploying a cloud run service:

```node
import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const defaultService = new gcp.cloudrun.Service("default", {
    location: "us-central1",
    template: {
        spec: {
            containers: [{
                image: "us-docker.pkg.dev/cloudrun/container/hello",
            }],
        },
    },
    traffics: [{
        latestRevision: true,
        percent: 100,
    }],
});
```


### Declarative

> [Declarative Programming] is a paradigm that expresses the logic of a computation without describing its control flow.

See example in **lab 020-compare-methods**.

#### Pros

- Usually no logic or very limited
- Immutable or greatly reduced mutability
- Very easy to understand
- Define target state with no need to understand current state

#### Cons

- Higher learning curve
- Additional tools
- Specialised, limited reuse of knowledge

#### Examples

- terraform
- [helm charts](https://helm.sh/docs/topics/charts/)
- kubernetes manifests
- docker compose


```hcl
resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}
```

## Terraform

[Terraform] is an open-source infrastructure as code software tool created by HashiCorp. Users define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

Terraform is the primary IaC tool to be used at IKEA. Aligning around a tool like terraform helps spread knowledge across the company and share effort through reusable modules.



### State

Used by terraform to store the last known state of the system in question.

Used to generate a diff, shows what needs to be changed in the target system

### Providers

Any API can be implemented as a provider.

Provider is business logic to handle how the API functions, eg: making sure
required fields are set, setting defaults, reducing work required to add
resources.





# ToDo

- multi tenancy









[Terraform State]: https://thorsten-hans.com/terraform-state-demystified
[Declarative Programming]: https://en.wikipedia.org/wiki/Declarative_programming
[Imperative Programming]: https://en.wikipedia.org/wiki/Imperative_programming
[Terraform]: https://en.wikipedia.org/wiki/Terraform_(software)
