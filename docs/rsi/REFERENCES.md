# Technical References

The architecture, operating modes, schemas, taxonomy, and acceptance criteria in
this package are proposed design choices based on the conversation. The sources
below support only the specific platform mechanics cited in the documents.
Official documentation was checked on 2026-10-01. Recheck relevant provider
behavior and organization settings when implementing; no API version or action
release is pinned by this package.

<a id="s1-agent-skills"></a>

## S1 — Agent Skills

[Agent Skills specification](https://agentskills.io/specification).
Supports the skill directory and `SKILL.md` frontmatter convention. It does not
establish this project's runtime hook, install directory, or access controls.

<a id="s2-github-contents-api"></a>

## S2 — GitHub Contents API

[REST API endpoints for repository contents](https://docs.github.com/en/rest/repos/contents).
Supports file create/update, required update SHA, conflict behavior, and directory
listing limitations. Serialization, event envelopes, and idempotency rules in
this package are design recommendations, not guarantees supplied by GitHub.

<a id="s3-github-actions-token"></a>

## S3 — GitHub Actions token

[`GITHUB_TOKEN`](https://docs.github.com/en/actions/concepts/security/github_token).
Supports the workflow token's repository scope. Verify current event-triggering
and review behavior for the exact automation credential used.

<a id="s4-github-app-authentication"></a>

## S4 — GitHub App authentication

[GitHub App authentication in Actions](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/making-authenticated-api-requests-with-a-github-app-in-a-github-actions-workflow).

[Generating an installation access token](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-an-installation-access-token-for-a-github-app).
Supports cross-repository App authentication and narrowing installation tokens
to permitted repositories/permissions. Application-level path restrictions and
process isolation remain implementation responsibilities.

<a id="s5-github-pull-requests"></a>

## S5 — GitHub pull requests

[REST API endpoints for pull requests](https://docs.github.com/en/rest/pulls/pulls).
Supports PR head/base and creation semantics. This package's candidate IDs and
reconciliation policy are proposed application behavior.

<a id="s6-protected-branches"></a>

## S6 — Protected branches

[About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches).
Supports review, status-check, stale-approval, and bypass-control concepts.
Availability and effective configuration must be checked on the actual target.

<a id="s7-sensitive-git-history"></a>

## S7 — Sensitive Git history

[Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository).
Supports the warning that ordinary file deletion is insufficient for removing
sensitive material from Git history. These documents do not provide or execute
a destructive history rewrite.
