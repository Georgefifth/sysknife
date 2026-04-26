# MCP servers registry submission

Submit SysKnife to the [official Model Context Protocol servers registry](https://github.com/modelcontextprotocol/servers)
so it appears alongside the canonical MCP servers (filesystem, github, brave-search,
etc.) and is discoverable via `https://modelcontextprotocol.io/`.

## What the registry expects

A PR to `modelcontextprotocol/servers` that adds an entry to `README.md`'s
"Third-party servers" section. Each entry is one row in the table:

| Server | Description | Repository |
|---|---|---|

## Submission text

When the maintainer's account is restored, open this PR against
`modelcontextprotocol/servers` (it's in the official org so a fork-and-PR is
the path):

**PR title:** `Add SysKnife — AI-managed Linux sysadmin via MCP`

**PR body:**

```markdown
This adds SysKnife to the third-party servers list.

[SysKnife](https://github.com/lacs-foundation/sysknife) is an open-source
implementation of the [LACS protocol](https://github.com/lacs-foundation/specification)
that exposes Linux system management as an MCP server. Two MCP tools:

- `sysknife_plan(intent)` — converts a natural-language intent into a typed,
  risk-classified plan
- `sysknife_execute(plan_id)` — executes the previously approved plan with
  live output streaming

The MCP layer enforces the same approval contract as the CLI: agents must call
`sysknife_plan` first, present the plan, wait for explicit human approval, then
call `sysknife_execute`. High-risk actions are refused outright at the MCP
boundary — they require the CLI/GUI confirmation flow.

License: MIT. Reference implementation in Rust. Supports Fedora 41+ /
Silverblue 41+ and Ubuntu 22.04 / 24.04 / 26.04 LTS. 50+ typed actions across
rpm-ostree, apt, snap, ufw, netplan, distrobox, AppArmor, fail2ban, and
Ubuntu Pro.

Setup: `npx sysknife-setup` writes the MCP config for Claude Code, Cursor,
or Codex CLI in one command.
```

**Table row to add to README.md** (alphabetical sort by server name):

```markdown
| **[SysKnife](https://github.com/lacs-foundation/sysknife)** | AI-managed Linux sysadmin — typed actions, risk gates, audit chain. | https://github.com/lacs-foundation/sysknife |
```

## After submission

The PR will likely be reviewed by the MCP maintainers (Anthropic /
ModelContextProtocol team). Standard checks:

- Does the project actually implement MCP? Yes — `crates/sysknife-cli/src/mcp_server.rs`
  exposes the protocol via `rmcp::ToolRouter`.
- Is it OSS? Yes, MIT.
- Is it maintained? Active development as of 2026-04.

Reviewer questions are typically minor (description rewording, table sort
order). Address inline; merge when approved.

## Related: awesome-mcp-servers

There's also a community-maintained list at
[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers).
Submit a parallel PR there with a similar table row. The community list
typically merges within hours; the official registry takes 1-3 days.
