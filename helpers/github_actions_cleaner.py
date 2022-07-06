from ghapi.all import GhApi
import os


def clean_github_actions(github_token: str, owner: str, repository: str):
    """This functions removes all the github worfklows runs for the given repository.
    One execution removes workflows runs on a single page, so multiple execution will
    be required to clean all workflows (cf https://docs.github.com/en/rest/reference/actions)."""

    os.environ["GITHUB_TOKEN"] = github_token
    api = GhApi()

    runs = api.actions.list_workflow_runs_for_repo(owner, repository)
    for run in runs.workflow_runs:
        api.actions.delete_workflow_run(owner, repository, run.id)

    print(f"Removed 1 page of workflows run on {owner}'s {repository} repository.")

    return


if __name__ == "__main__":

    owner = "gbto"
    repository = "pants-default-lock"
    github_token = os.environ.get("GITHUB_PAT_PERSO")

    clean_github_actions(github_token, owner, repository)
