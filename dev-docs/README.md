# Official Solr Dockerfile Management

In general most interactions with this repository should be done via the Solr Release Wizard, not manually.

## How an Official Solr Dockerfile is released

1. In the Solr Release Wizard, an **official** Dockerfile will be created as a part of the release candidate.
   The official Dockerfile is tested as a part of the release candidate.
   1. But importantly, the official Dockerfile is not voted on because small changes _may_ be requested by the Official Images team.
      We need to be able to make changes for these requests **after** a vote succeeds.
2. If the vote succeeds:
   1. As a part of the artifact-uploading steps, the Release Wizard will clone this repo (`apache/solr-docker`) locally.
   2. It will then add the successfully voted on `Dockerfile` to the respective folder for the released version (`<major>.<minor>`).
   3. If it is a patch release, the existing `Dockerfile` for that version will be over-written.
   4. It will commit this `Dockerfile`, and push to the `main` branch of this repo. No PR or reviews required.
3. Now that this repo has the new `Dockerfile` committed to main, the [Github Actions Workflow](../.github/workflows/pr-for-official-repo.yml) will kick-off.
   1. It will use [`generate-stackbrew-library.sh`](../generate-stackbrew-library.sh) to build the [Solr metadata](https://github.com/docker-library/official-images/blob/master/library/solr) for the latest `main` branch commit.
   2. After generating a new version of this file, it will create a PR in [docker-library/official-images](https://github.com/docker-library/official-images) to update the official image.
   3. This PR will have to be reviewed and merged by the Docker Official Images team before the release will be available.
      1. If a change to the Dockerfile/metadata is required by the maintainers, make further PRs/commits to this repo.
         Refer to the [section on making fixes for an open PR](#make-fixes-for-an-open-automated-pr) for more information.
   4. Before the PR can be approved, one of the listed Solr maintainers must comment their approval of the PR.
4. The Official Docker image should now be available

## How does the automated PR work?

The [Github Actions Workflow](../.github/workflows/pr-for-official-repo.yml) is triggered on commits to the `main` branch that touch the following files:
- `generate-stackbrew-library.sh`
- `*.*/Dockerfile`

The PR in [docker-library/official-images](https://github.com/docker-library/official-images) is generated through:
- Creating a branch in the [docker-solr/official-images](https://github.com/docker-solr/official-images).
  - We have to use this repo, because Apache does not allow forks in their organization.
- This commit is made by the [@docker-solr-builder](https://github.com/docker-solr-builder), which has credentials saved in this repo.
  - These credentials were added by emailing them to the Apache infra-team (`root@`)
  - If you need access to this account or credentials, reach out to the private mailing list.
- Once the commit and branch are created, the Github Action will create a PR in the official repo.

### Make fixes for an open automated PR

If the PR in [docker-library/official-images](https://github.com/docker-library/official-images) is already created & open,
any commit you make to this repo will auto-update the existing PR.
The commit has to change the files that the Github Actions Workflow is listening on, which are [listed above](#how-does-the-automated-pr-work).

The PR name will change to reflect the most recent commit message, and the pr description will link to this commit instead.
The PR contents will be updated to reflect the generated solr image metadata made from the latest commit.
There is no need to close an existing PR to make further changes.

**Make sure that all changes to Dockerfiles are reflected in the official source of these dockerfiles, [apache/solr](https://github.com/apache/solr).
This will ensure that the official-images team does not ask for the same changes in future releases.
This speeds up the release process and ensures that the Dockerfile provided in the binary-release is as similar as possible to the official Solr Dockerfile.**
