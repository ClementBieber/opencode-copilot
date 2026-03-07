# Published Project Document Boundaries

Status: canonical publication document policy

## 1. Purpose

This guide defines what publication-facing root documents should contain.

## 2. `README.md`

Owns:
- public project description
- short quick start
- concise deployment overview
- links to canonical deeper docs

Must stay concise.

## 3. `INSTRUCTIONS.md`

Owns:
- a thin operator-facing entry point for published projects
- links to canonical publication/deployment docs

It should not become the canonical owner of deep operational knowledge if that knowledge already lives in this skill.

## 4. `AGENTS.md`

Owns:
- project-specific overview
- general structure
- architecture summary

It should not own publication workflow details.

## 5. Publication Rule

If a project is not published or externally consumed, `INSTRUCTIONS.md` should usually not exist.

If the project is published, keep `INSTRUCTIONS.md` thin and let this skill own the detailed guidance.
