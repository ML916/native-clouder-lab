import shutil
import os
import click
import subprocess
import logging

logger = logging.getLogger('cli')
logger.setLevel(logging.DEBUG)


def pr(message, **kwargs):
    return click.echo(message=message, **kwargs)

def exec(cwd, command):
    res = subprocess.run(command, cwd=cwd)
    logger.debug("CMD args: ", res.args)


@click.group()
@click.option('--debug/--no-debug', default=False, envvar='REPO_DEBUG')
@click.pass_context
def cli(ctx, debug):
    """Setup Click."""

    labs = sorted(next(os.walk(os.environ["LABS_DIR"]))[1])
    lab = os.getcwd().split("/")[-1]
    ctx.obj = {
        "support_dir": os.environ["SUPPORT_DIR"],
        "labs_dir": os.environ["LABS_DIR"],
        "labs": labs,
        "lab": lab if lab in labs else None,
        "cwd": os.getcwd(),
    }


def run_terraform(ctx, command, auto_approve=False, auto_var=False):
    """Clean up the environment."""
    cmd = ["terraform", command]

    if command == "init":
        pr(exec(ctx["cwd"], command=cmd))
        return

    auto_var = auto_var and ctx["lab"] in ["260-variables"] and command in ["destroy", "plan", "apply"]
    if auto_var:
        cmd.append('-var=something-without-default=foo')

    if ctx["lab"] == "260-variables":
        cmd.append("-var-file=env.tfvars")

    if command in ['apply', 'destroy'] and auto_approve:
        cmd.append('-auto-approve')

    if command in ['destroy']:
        cmd.append('-destroy')
        command = "apply"
        cmd[1] = command

    pr(exec(ctx['cwd'], command=cmd))

@cli.command()
@click.argument('command', required=True, type=click.Choice(['plan', 'apply', 'clean', 'init', 'providers'], case_sensitive=True))
@click.option('--auto-approve', default=False, is_flag=True, help='Skips interactive approval of plan before applying.')
@click.pass_obj
def terraform(ctx, command, auto_approve):
    return run_terraform(ctx, command=command, auto_approve=auto_approve)

@cli.command()
@click.pass_obj
def bulk_run(ctx):
    """Run all labs."""
    for lab in ctx['labs']:
        logger.info(f"Running lab: [{lab}]")
        ctx = {**ctx, "cwd": f"/labs/{lab}", "lab": lab}
        run_terraform(ctx, "init")
        run_terraform(ctx, "plan", auto_var=True)
        run_terraform(ctx, "apply", auto_approve=True, auto_var=True)

@cli.command()
@click.option('--terraform', default=True)
@click.option('--docker', default=True)
@click.pass_obj
def bulk_clean(ctx, terraform, docker):
    """Run terraform commands."""
    for lab in ctx['labs']:
        logger.info(f"Cleaning up lab: [{lab}]")
        if terraform:
            ctx = {**ctx, "cwd": f"/labs/{lab}", "lab": lab}
            run_terraform(ctx, "init", auto_approve=False)
            run_terraform(ctx, "destroy", auto_approve=True, auto_var=True)

            try:
                shutil.rmtree(f"{ctx['cwd']}/.terraform")
            except FileNotFoundError:
                pass
            try:
                shutil.rmtree(f"{ctx['cwd']}/output")
            except FileNotFoundError:
                pass
            try:
                os.remove(f"{ctx['cwd']}/terraform.tfstate")
            except FileNotFoundError:
                pass
            try:
                os.remove(f"{ctx['cwd']}/terraform.tfstate.backup")
            except FileNotFoundError:
                pass
            try:
                os.remove(f"{ctx['cwd']}/.terraform.lock.hcl")
            except FileNotFoundError:
                pass

        if docker:
            pass


if __name__ == '__main__':
    cli()
