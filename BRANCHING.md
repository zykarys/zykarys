# Branching

Habit (locked 2026-09-23):

1. **Push to `dev`** — all day-to-day work lands here first.
2. **QA** — review on `dev` (Pages preview / local / diff vs `main`).
3. **Sync to `main`** — only after QA: fast-forward or PR `dev` → `main`.

`main` is production. Do not push feature work straight to `main` unless kv explicitly says so.
