# Official Solr Dockerfile Management

In general most interactions with this repository should be done via the Solr Release Wizard, not manually.

## How an Official Solr Dockerfile is released

1. In the Solr Release Wizard, an **official** Dockerfile will be created as a part of the release candidate.
   The release candidate is tested and voted on, including the Dockerfile.
2. If the vote succeeds:
   1. As a part of the artifact-uploading steps, the Release Wizard will clone this repo (`apache/solr-docker`) locally.
   2. It will then add the successfully voted on `Dockerfile` to the respective folder for the released version (`<major>.<minor>`).
   3. If it is a patch release, the existing `Dockerfile` for that version will be over-written.
   4. It will commit this `Dockerfile`, and push to the `main` branch of this repo. No PR or reviews required.
3. Now that this repo has the new `Dockerfile` committed to main, the [Github Actions Workflow](../.github/workflows/pr-for-official-repo.yml) will kick-off.
   1. It will use [`generate-stackbrew-library.sh`](../generate-stackbrew-library.sh) to build the [Solr metadata](https://github.com/docker-library/official-images/blob/master/library/solr) for the latest `main` branch commit.
   2. After generating a new version of this file, it will create a PR in [docker-library/official-images](https://github.com/docker-library/official-images) to update the official image.
   3. This PR will have to be reviewed and merged by the Docker Official Images team before the release will be available.
   4. Before the PR can be approved, one of the listed Solr maintainers must comment their approval of the PR.
4. The Official Docker image should now be available

## How does the automated PR work?

The [Github Actions Workflow](../.github/workflows/pr-for-official-repo.yml) is triggered on commits to the `main` branch that touch the following files:
- `generate-stackbrew-library.sh`
- `*.*/Dockerfile`

The PR is generated through:
- Creating a branch in the [docker-solr/official-images](https://github.com/docker-solr/official-images).
  - We have to use this repo, because Apache does not allow forks in their organization.
- This commit is made by the [@docker-solr-builder](https://github.com/docker-solr-builder), which has credentials saved in this repo.
  - These credentials were added by emailing them to the Apache infra-team (`root@`)
  - If you need access to this account or credentials, reach out to the private mailing list.
- Once the commit and branch are created, the Github Action will create a PR in the official repo.
