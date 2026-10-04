# Package Validation and Limitations

Validated in the authoring environment on 2026-10-01:

- All three JSON Schema documents satisfy the Draft 2020-12 meta-schema.
- Five JSON examples validate against their corresponding contracts: extractor
  observation, empty extractor output, stored observation capture, stored empty
  capture, and candidate revision.
- Seven negative structural cases are rejected: unverified claimed success,
  model-authored repository field, missing supporting references, distillation
  captured as task execution, inconsistent empty outcome, a shared candidate
  without consumers, and target path traversal.
- Evidence references in the sample capture resolve to its evidence entries;
  the sample candidate points to the sample observation.
- Relative Markdown file links and explicit reference anchors are checked.
- Skill frontmatter is parsed and its name matches its containing directory.
- JSON and YAML assets parse, archive payload hashes match their manifest, and
  ZIP entries are relative and remain inside the package.

These checks do **not** establish semantic extraction quality, reference
truthfulness on arbitrary real input, production privacy safeguards, prompt
injection resistance, permission enforcement, routing correctness, or agent
performance. Those require runtime checks and the evaluation suite described in
the architecture documents.

The PowerShell installer was inspected as source but not executed: PowerShell
and the user's Windows filesystem are not available in the authoring environment.
No tests were run against the actual local project, GitHub repositories, branch
protections, CI, production models, or live agents. This package does not claim
that the described system or common skill has been installed.
