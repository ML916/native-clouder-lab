# ikealab - CI & CD Pipelines

This lab will take you through the basic things that you should implement in order to safely and fearlessly deliver constant new value.

## Business Case

In order to iterate quickly and constantly deliver new value, we need to make deployment to Production **insignificant**.

The team needs to be confident that they can trigger a release at any time and the application will:

- deploy flawlessly every time
- function the way it was intended
- be performant and scale as expected
- has no known security issues
- works with its dependencies
- has no release overhead such as manual creation of release notes

## Engineering thinking

- What practices in the team would enable automatic release and versioning?
- How can all aspects of the software and its operation be tested as frequently as possible?
- How can we catch issues with any aspect as early as possible?
- What would be the components of a pipeline that fully tests all aspects in an automated way?
- How would the jobs change from language to language?
- What variations would exist between a frontend application and a backend application?
- How many pipelines would we need for a single service?
- What outputs would we want from each pipeline?
- How can we follow the IKEA Key Values for simplicity and cost-consciousness to achieve our business case?
- What is the best available set of tools and technologies I can use for that?

## A way to do it - hands-on

- [Conventional Commits](./hands-on/conventional-commits.md)
- [Plan the components of your workflow](./hands-on/planning_workflows.md)
- [Writing & Testing your first workflow](./hands-on/writing_your_first_workflow.md)
- [Finding actions and resuable workflows](./hands-on/finding_actions_and_workflows.md)
- [OIDC Setup](./hands-on/oidc_setup.md)

## Clean-up and Billing

- Remove any environments created by your pipelines (you can always run the pipeline again later to get them back!)

## Wrap up and reflection

- reflect on ... key learning on how to apply the IKEA Key Values into our Engineering while developing Digital Products
- what is your key take away ...
- what is still unclear for you ...

# lab maintainers

- @erzz
