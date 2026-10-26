#!/usr/bin/env bash
# Throwaway test for .githooks/pre-push. Usage: bash test.sh /path/to/pre-push
set +e; HOOK=${1:-/workspace/vguard/pre-push}; T=$(mktemp -d); cd $T; git init -q --bare -b main remote.git; git clone -q remote.git w 2>/dev/null; cd w; G="git -c user.name=t -c user.email=t@t"; mkdir .githooks; cp "$HOOK" .githooks/pre-push; git config core.hooksPath .githooks
cl() { printf '# Changelog\n\n## [Unreleased]\n%s\n' "$2" > CHANGELOG.md; for v in $1; do printf '\n## [%s] - 2026-10-26\n- x\n' $v >> CHANGELOG.md; done; }
rel() { echo $1 > VERSION; cl "$2" "$3"; git add -A; $G commit -qm "v$1"; [ "$4" = notag ] || $G tag -a v$1 -m v$1; }
pass=0; bad=0
t() { out=$(git push -q origin ${3:-main} 2>&1); rc=$?; got=$([ $rc = 0 ] && echo pass || echo block); [ -n "$4" ] && { echo "$out" | grep -q WARNING && got="$got+warn"; }; if [ "$got" = "$2" ]; then pass=$((pass+1)); r=OK; else bad=$((bad+1)); r=FAIL; fi; printf '%-4s %-46s expected=%-10s got=%s\n' $r "$1" "$2" "$got"; }
undo() { for x in "$@"; do git tag -d $x >/dev/null; done; git reset -q --hard HEAD~1; }
rel 0.1.0 "0.1.0"; t "first push, no remote VERSION" pass
echo a>>f; git add f; $G commit -qm nobump; t "push to main without a bump" block; git reset -q --hard HEAD~1
rel 0.1.1 "0.1.1 0.1.0"; t "patch bump 0.1.0->0.1.1" pass
rel 0.1.3 "0.1.3 0.1.1 0.1.0"; t "skipped patch 0.1.1->0.1.3" block; undo v0.1.3
rel 0.3.0 "0.3.0 0.1.1 0.1.0"; t "skipped minor 0.1.1->0.3.0" block; undo v0.3.0
rel 0.2.1 "0.2.1 0.1.1 0.1.0"; t "minor without patch reset 0.2.1" block; undo v0.2.1
echo 0.1.0 > VERSION; git add -A; $G commit -qm down; t "version goes down" block; git reset -q --hard HEAD~1
rel 1.0.0 "1.0.0 0.1.1 0.1.0"; t "major bump 0.1.1->1.0.0" block; undo v1.0.0
rel 0.2.0 "0.2.0 0.1.1 0.1.0" "" notag; t "minor bump, missing tag" block
$G tag v0.2.0; t "lightweight (not annotated) tag" block; git tag -d v0.2.0 >/dev/null; git reset -q --hard HEAD~1
echo '{"name":"x","version":"0.1.9"}' > package.json; rel 0.2.0 "0.2.0 0.1.1 0.1.0"; t "package.json mismatch" block; undo v0.2.0
echo '{"name":"x","version":"0.2.0"}' > package.json; rel 0.2.0 "0.1.1 0.1.0"; t "CHANGELOG entry missing" block; undo v0.2.0
rel 0.2.0 "0.2.0 0.1.1 0.1.0"; t "minor bump + package.json, all good" pass
rel 0.2.1 "0.2.1 0.2.0 0.1.1 0.1.0"; rel 0.2.2 "0.2.2 0.2.1 0.2.0 0.1.1 0.1.0"; t "two valid releases in one push" pass
git checkout -q -b dev; echo b>>f; git add f; $G commit -qm devwork; t "dev push, no [Unreleased] line" pass+warn dev w
cl "0.2.2 0.2.1 0.2.0 0.1.1 0.1.0" "- (patch) thing"; git add -A; $G commit -qm devwork2; t "dev push with (patch) line" pass dev w
git checkout -q main; t "delete main" block :main
rel 1.0.0 "1.0.0 0.2.2"; echo "1.0.0 kV approval: chat 2026-10-26" > .major-approved; t "major with .major-approved (kV only)" pass
echo "== $pass passed, $bad failed"; cd /; rm -rf "$T"
