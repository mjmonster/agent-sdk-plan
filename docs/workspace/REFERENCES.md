# Primary Technical References

Consulted for this design on 2026-10-01 (America/Los_Angeles). Links support vendor-specific capabilities and limitations, not a claim that the user's environment is configured that way. The architecture, defaults, and state models are proposed engineering decisions.

<a id="g1-repository-access"></a>

## G1 — Repository access
[GitHub: Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization)

Repository roles and repository-level read/write capabilities underpin the access-boundary recommendation.

<a id="g2-protected-branches"></a>

## G2 — Protected branches
[GitHub: About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

Required reviews/checks, stale-review behavior, expected check source, available plans, and bypass settings.

<a id="g3-code-owners"></a>

## G3 — Code owners
[GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)

Ownership-based review and the behavior of multiple listed owners.

<a id="g4-pull-request-reviews"></a>

## G4 — Pull request reviews
[GitHub REST API: Pull request reviews](https://docs.github.com/en/rest/pulls/reviews)

Provider review identity, state, submission time, and reviewed commit evidence.

<a id="g5-pull-request-merge"></a>

## G5 — Pull request merge
[GitHub REST API: Pull requests](https://docs.github.com/en/rest/pulls/pulls)

Merge operation and expected-head SHA parameter.

<a id="g6-git-reference-updates"></a>

## G6 — Git reference updates
[GitHub REST API: Git references](https://docs.github.com/en/rest/git/refs)

Non-forced reference updates and fast-forward protection.

<a id="j1-jira-issues"></a>

## J1 — Jira issues
[Atlassian: Jira Cloud platform REST API, issues](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/)

Issue creation, permitted metadata, and workflow transition operations.

<a id="j2-jira-backlog"></a>

## J2 — Jira backlog
[Atlassian: Jira Software Cloud REST API, backlog](https://developer.atlassian.com/cloud/jira/software/rest/api-group-backlog/)

Backlog operations and their relation to sprint membership and boards.

<a id="j3-scrum-backlog"></a>

## J3 — Scrum backlog
[Atlassian: Use your Scrum backlog](https://support.atlassian.com/jira-software-cloud/docs/use-your-scrum-backlog/)

Backlog visibility and board filtering conditions.

<a id="j4-jira-remote-links"></a>

## J4 — Jira remote links
[Atlassian: Jira Cloud platform REST API, issue remote links](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-remote-links/)

External navigation links and global-ID-based updates.

<a id="j5-jira-webhooks"></a>

## J5 — Jira webhooks
[Atlassian: Jira Software Cloud webhooks](https://developer.atlassian.com/cloud/jira/software/webhooks/)

Retry behavior, stable retry identifiers, and supported webhook verification considerations.
