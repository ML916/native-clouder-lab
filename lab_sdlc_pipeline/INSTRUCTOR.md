# Instructor Guideline for running this IKEA lab

## Intro

- Me, Role, IKEA History
- Camera on at all times
- Not a lecture - please interrupt, ask questions, challenge things

# HANDS-ON 001: Draw a CICD Pipeline (10 minutes)

- https://miro.com/welcomeonboard/emEyUWZnbnU4eXQ0R004WkRQdFd6RXRydUJhZ3lUWGdrWjF3bHU1d3l1TldrT01aM3JRc285UjVHSEhIM1UxVHwzMDc0NDU3MzQ3MzgwMzA2NDY4?invite_link_id=439024780361

# Business case

## **STUDENT QUESTION:** Why is it important to iterate quickly and frequently?

- [Boyd's Law of Iteration](https://blog.codinghorror.com/boyds-law-of-iteration/)

## **STUDENT QUESTION:** Why is this lab NOT called CICD pipelines?

## **STUDENT QUESTION:** WHAT IS CI?

- What is CI (isnt it just merging a lot? - whats the connection with pipelines?)

### The CI "Definition"

  - 1) are all the engineers pushing their code into trunk / master (not feature branches) on a daily basis?
  - 2) does every commit trigger a run of the unit tests?
  - 3) When the build is broken, is it typically fixed within 10 minutes?

## **STUDENT QUESTION:** WHAT IS CD?

  - Reducing risk
  - Do difficult things as often as possible
  - Real progress as opposed to imagined completion of task

### The CD Pattern
  1) Low-risk Releases are Incremental
  2) Decouple Deployment and Release
  3) Focus on Reducing Batch Size
  4) Optimize for Resilience

## CONCLUSION

So what about the rest? Continuous Testing? Security? Performance? Post Release? etc etc

## Demo an existing project

  - multiple workflows
  - multiple types of tests
  - dedicated release
  - post production use case
  - artifacts
  - etc

# SDLC Pipelines

![The BFD](/labs/lab_sdlc_pipeline/media/DORA_BFD.jpg)

## Start with the outcome

## **STUDENT QUESTION:** What causes fear and stress around releasing a service to production

  - Might not work
  - Not sure its tested properly
  - What if the deployment fails?
  - What if the system goes down
  - What if the performance is bad?
  - What if a bug corrupts data
  - What if I added a security hole?
  - What if I accidentally committed something secret?
  - What if we can't track down the change that caused the problem?
  - **What if it's my fault?**

### **STUDENT QUESTION:** What is the desired outcome of SDLC pipelines?

- Simplify the concept and its all about insignificant, reliable, stress-free releases
- Given that outcome lets start there and work backwards

# Engineering Thinking

## Lets start with automating Release

**STUDENT QUESTION:** What is the difference between Release & Deploy to prod?

- decoupled
- release != deployed
- feature flags
- A Release == packaged & documented for deployment
- Released == In use by consumers
- Deploy may happen many times, in different places, repeatable
- Definitions may vary - the important thing is the decoupling

## Automatic release creation and versioning

**STUDENT QUESTION:** What is included in a release?

- documentation
  - release notes
  - evidence for compliance
- artifacts / assets
  - user / upgrade instructions
  - technical docs
  - binaries
  - docker image
  - deployment & automation
- A version number

**STUDENT QUESTION:** How do we decide on a version number?

![semantic version](/labs/lab_sdlc_pipeline/media/semantic-versioning.png)

**STUDENT QUESTION:** Why is this important?

- safe to update?
- pinning versions
- informative
- structured

**STUDENT QUESTION:** So if we are automating this, how can a computer decide?

## Commit Message Conventions

### Anatomy of a commit message

READ THIS:

http://karma-runner.github.io/1.0/dev/git-commit-msg.html

READ IT AGAIN!

Lets start with a bad example:

![bad-commits](/labs/lab_sdlc_pipeline/media/bad-commits.png)

Bad Examples: https://www.codelord.net/2015/03/16/bad-commit-messages-hall-of-shame/

And a better example:

![better-commits](/labs/lab_sdlc_pipeline/media/better-commits.png)

Conventional: https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716

Other examples:
- https://dev.to/i5han3/git-commit-message-convention-that-you-can-follow-1709

**STUDENT QUESTION:** What benefits from this?

  - clarity of purpose
  - Skimmable history
  - encourages not to combine a bug-fix with feature in a single commit
  - produce a CHANGELOG
  - produce release notes
  - use to determine versioning

## Semantic Release

**STUDENT QUESTION:** What should trigger a release?

  - should we disturb production for an internal docs update?
  - should we disturb production for test update
  - should we disturb production for refactoring
  - perf? style? chore? feat? fix? ci? BREAKING?

# HANDS-ON 002: Commit & Release (10-15 mins)

https://github.com/ingka-group-digital/cloud-native-sdlc-sandbox

* Create some commits using a commit convention
* test the release workflow

# Planning Workflows

**STUDENT QUESTION:** Given that we want to be 100% confident in every release... what could be in a pipeline?

# HANDS-ON 003: Refresh your pipelines (10 mins)

Given what we know now about the outcome - update your pipelines with what you now think should be in your pipelines.

- https://miro.com/welcomeonboard/emEyUWZnbnU4eXQ0R004WkRQdFd6RXRydUJhZ3lUWGdrWjF3bHU1d3l1TldrT01aM3JRc285UjVHSEhIM1UxVHwzMDc0NDU3MzQ3MzgwMzA2NDY4?invite_link_id=439024780361

# GROUP REVIEW

  - Functionality
    - Unit
    - Integration
    - Browser
    - Accessibility
    - Contract Testing
    - Fuzz Testing
  - Performance (will depend on a level of instrumentation)
    - Throughput
    - Unit of deployment sizing
    - Browser performance
    - Response Time
    - Scaling
    - Infrastructure
  - Deployment & Rollout
    - What kind of deployments needed?
      - Preview environments
      - main
      - production
    - terraform
    - gcloud
    - multiple services (sequencing / checks / opportunities for decoupling)
    - monitoring, alerts, dashboards, etc
  - Security
    - Image packages
    - App dependencies
    - SAST
    - DAST
    - Secrets
    - IaC
    - Code Quality / Linting
    - Best practices (Hado, Dockle etc)
  - Build
    - Linting
    - Compilation
    - Packaging (CF, Dockerfile)
    - Distribution
  - Other
    - Lint the commits
    - Produce a swagger spec and publish
    - Triggers to other pipelines
    - Publish release notes
    - Collect evidence (e.g. PCI / DSS)
    - Static file sizes
    - Generate test coverage
  - When should those jobs run?
    - Every push? First Push? On PR, On release?
  - How can we keep simplicity in mind
    - Not buying / using a ton of specialised tools for things like deployment (Spinnaker, giant test suites, etc)
    - Open source, actions, same tools as will be used in execution
    - Every job should provide value!
    - Every job should be fast

# PERHAPS LUNCH HERE?

# Writing your first workflow

- How does a CI engine work?
  - [Github Runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners)
  - [Installed Software](https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md)
  - [Containers](https://dev.to/mihinduranasinghe/using-docker-containers-in-jobs-github-actions-3eof)

## HANDS-ON 004: Basic Build Workflow (20-30 mins)
- Intro to Github actions syntax
- File location `.github/workflows/my-workflow.yml`
- Basic docker build (no push, we need auth for that)
- What causes a job to Pass / Fail?

## HANDS-ON 005: Extending the workflow (20-30 mins)

- Discuss secrets
- Discuss contexts https://docs.github.com/en/actions/learn-github-actions/contexts
- Discuss outputs, inputs and env 

```yaml
name: Feature
on:
  push:
    branches-ignore:
      - main

jobs:
  build-image:
    name: Build Container Image
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source
        uses: actions/checkout@v2
        with:
          fetch-depth: 1

      - name: Build Image
        run: docker build -t ${{ github.event.repository.name }}:latest .

  unit-tests:
    name: Unit Tests
    runs-on: ubuntu-latest
    outputs:
      result: ${{ steps.unit-tests.outputs.unit-test-result }}
    steps:
      - name: Checkout Source
        uses: actions/checkout@v2

      - name: Run Unit Tests
        env:
          NAME: sean
        run: |
          echo "Unit Tests are running..."
          if [ "$NAME" = "sean" ]; then 
            echo "::set-output name=unit-test-result::PASS"
            echo "pass" && exit 0
          else
            echo "::set-output name=unit-test-result::FAIL"
            echo "fail" && exit 1
          fi

  collate-test-results:
    name: Unit Tests
    runs-on: ubuntu-latest
    needs: unit-tests
    steps:
      - name: Print Results
        run: echo "The result of the Unit Tests was ${{ needs.unit-tests.outputs.result }}"
```

# Finding actions and workflows

- Simplicity - instead of wrapping 1000's line of shell script, re-use great actions (be careful which you choose)
  - e.g. switch our our build job for https://github.com/mr-smithers-excellent/docker-build-push
- https://github.com/marketplace?category=&query=&type=actions&verification=
- Always an option to write your own action for common tasks
- Are you the first person to ever need a job for X? (Likely No!)
- Reusable workflows - https://github.com/ingka-group-digital/retail-pim-admin

## HANDS-ON 006: Adding an action based job (30 mins)

## OIDC Setup

- In the example above we built image but never pushed
- We need auth for that
- Usual docs say use SA key, Don't
- Workload Identity Federation between GCP & Github

## Resuable Workflows

- What
- Why

![reusable](/labs/lab_sdlc_pipeline/media/reusable.png)
