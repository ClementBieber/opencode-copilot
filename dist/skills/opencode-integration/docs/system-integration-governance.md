# System Integration Governance

Status: draft  
Scope: Linux/OpenCode environment integration  
Canonical owner: `opencode-integration`

## 1. Purpose

This document defines how new tools integrate into the broader OpenCode/Linux environment.

## 2. Preferred Evaluation Order

When adding a new tool:

1. define its purpose
2. decide whether it is repo-level or system-level
3. choose a canonical install location
4. define version/pinning policy
5. define how agents discover or invoke it
6. define rollback/removal path

## 3. System Layers

- repo source of truth
- deployed OpenCode config in `~/.config/opencode`
- user binaries in `~/.local/bin`
- managed runtimes (node/python/etc.)
- optional system-wide tooling only when justified

## 4. Default Rule

Prefer:
- user-level
- reversible
- pinned
- documented

Avoid implicit machine-wide mutations.

## 5. Publication Note

`INSTRUCTIONS.md` should exist only for published/external-facing projects.

If publication workflows become substantial, create a dedicated publication skill instead of expanding unrelated skills.
