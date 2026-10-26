# Contributing: versioning

This repository uses `MAJOR.MINOR.PATCH` ([SemVer 2.0.0](https://semver.org/spec/v2.0.0.html)) under the lab versioning policy set by kV on 2026-10-26.
The full policy is `domains/operations/VERSIONING.md` in `zykarys/zykarys-lab`. The short version follows.

- **Source of truth:** `VERSION` (one line, `X.Y.Z`) on `main`, an annotated tag `vX.Y.Z` on the commit that set it, and `CHANGELOG.md` ([Keep a Changelog](https://keepachangelog.com/en/1.1.0/)). If there's a `package.json`, its `version` mirrors `VERSION`.
- **Only `main` is released and tagged.** On `dev` or any other branch, add `- (minor|patch) <what>` under `## [Unreleased]` and leave `VERSION` alone. Merging to `main` bumps once, by the highest class waiting.
- **MINOR:** a new page type, section or capability goes live, or something public is deprecated.
- **PATCH:** one new post, fixes, copy, style, headers or config, docs.
- **MAJOR:** anything that breaks the public contract (published URLs, feeds, `/api/*`, the domain, the license) and the move from 0.x to 1.0.0. **Never without ceremony:** write a proposal, discuss it with kV, and get kV's explicit "yes, major" in chat. No agent bumps a major on its own.

## Before every push

1. Classify the change as patch or minor. If it looks breaking, stop and raise it with kV.
2. On `main`: bump `VERSION` (and `package.json`), and add a dated changelog entry. Elsewhere: add an `[Unreleased]` line.
3. The change, the bump and the changelog entry go out in the same push.
4. Tag `main` releases with `git tag -a vX.Y.Z -m "vX.Y.Z — <summary>"`, then `git push origin main vX.Y.Z`.
5. Check that `VERSION`, the newest changelog heading, the tag and `package.json` all agree. Never move or delete a pushed tag: fix forward with a patch.

## Pre-push hook (enforced)

`.githooks/pre-push` (the version guard) refuses any push that updates `main` unless all of these hold:
- `VERSION` ticks exactly one step: patch +1, or minor +1 with the patch reset to 0.
- MAJOR is unchanged.
- `CHANGELOG.md` has a `## [X.Y.Z] - YYYY-MM-DD` entry.
- `package.json` (if any) matches `VERSION`.
- An annotated tag `vX.Y.Z` is on the pushed commit.

Pushes to other branches only warn when `[Unreleased]` gets no `(minor)` or `(patch)` line.

- Turn it on once per clone: `git config core.hooksPath .githooks`. Test it with `bash .githooks/test-pre-push.sh .githooks/pre-push`.
- **Never use `--no-verify`** on this repo. Bypassing the guard needs kV's explicit confirmation.
- A major bump passes only with a `.major-approved` file naming the exact version and kV's approval. It is created only after kV's ceremony. **Agents never create it.**
