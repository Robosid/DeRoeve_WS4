# Lab 0: Setup + AI Operating Model

## Objective
Standardize how the team uses Copilot in SSMS so outputs are consistent, auditable, and production-relevant.

## Tools
- SSMS 22.7.0
- Copilot Chat in SSMS

## Steps
1. Confirm Copilot chat opens inside SSMS.
2. Confirm model picker shows locally validated models.
3. Set reasoning level based on task complexity:
   - Low: small rewrites, quick fixes
   - Medium: standard query/procedure generation
   - High: architecture-level SQL design, complex tuning
4. Practice context scoping:
   - `#selection` for focused edits
   - `#editor` for full active query
   - `#file` for referenced SQL file
5. Run slash commands baseline:
   - `/explain`
   - `/fix`
   - `/tests`
   - `/doc`

## Prompt Drills
- "Review this query for correctness and performance in an IIoT workload with noisy telemetry. Return findings and a rewritten query."
- "Generate a reusable checklist for SQL proc changes that includes plan review, row correctness checks, and test updates."
- "Given this alarm rollup query, propose two alternatives: one for readability and one for performance."

## Deliverables
- Completed prompt playbook file in `prompts/team-prompt-playbook-template.txt`
- One saved reusable prompt per participant
- One model-routing guideline agreed by team

## Validation
- Every participant can execute one prompt and one follow-up refinement.
- Team agrees on a default model-routing policy by task type.
