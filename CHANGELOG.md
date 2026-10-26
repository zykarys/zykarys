# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html) under the lab policy in [CONTRIBUTING.md](CONTRIBUTING.md).

Versions before 0.1.4 were estimated from the commit history on 2026-10-26 and are not tagged. For older lines, the patch releases between minors are folded into their minor's entry.

## [Unreleased]

## [0.1.5] - 2026-10-26
### Added
- `.githooks/pre-push` version guard (kV, 2026-10-26: "Build pre-push check to ensure version ticks every time"). Pushes to `main` are blocked unless `VERSION` ticks exactly one step (patch, or minor with the patch reset), MAJOR is unchanged (a major needs kV's ceremony), `CHANGELOG.md` has the dated entry, `package.json` matches, and an annotated `vX.Y.Z` tag is on the pushed commit. Other branches only get a warning about `[Unreleased]` lines. Plus `.githooks/test-pre-push.sh`.
### Changed
- `CONTRIBUTING.md`: the pre-push hook section; never use `--no-verify`.

## [0.1.4] - 2026-09-23
### Changed
- KeMeK Network © 2026 footer; branching habit (dev → QA → main).
- `VERSION`, `CHANGELOG.md` and `CONTRIBUTING.md` added (2026-10-26; the version was estimated from history).

## [0.1.3] - 2026-09-23
### Removed
- Brand-page closer.

## [0.1.2] - 2026-09-23
### Added
- Link to zykarys.com.

## [0.1.1] - 2026-09-23
### Changed
- Profile README expanded; argumentative line dropped.

## [0.1.0] - 2026-09-23
### Added
- Initial profile README.

[Unreleased]: https://github.com/zykarys/zykarys/compare/v0.1.5...HEAD
[0.1.5]: https://github.com/zykarys/zykarys/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/zykarys/zykarys/releases/tag/v0.1.4
