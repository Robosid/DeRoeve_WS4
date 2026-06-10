# Lab 6: SSAS AI Semantic Modeling

## Objective
Use AI to design a production-relevant SSAS tabular semantic layer for IIoT/SCADA KPI analytics.

## Tools
- SSMS 22.7.0 (Analysis Services support)
- SSAS Tabular tooling
- Copilot (for model and DAX design)

## AI-first flow (majority AI work)
1. AI/chat work (majority):
  - Run Prompt Starter #1, Prompt Starter #2, and Prompt Starter #3 in Copilot Chat.
  - Iterate on model, DAX, and refresh strategy prompts until assumptions are explicit.
2. Manual execution work (supporting validation):
  - Execute baseline SQL and compare DAX outputs against captured SQL checkpoints.

## Inputs
- Fact telemetry and event data from prior labs
- KPI requirements: OEE, Availability, Performance, Quality

## Setup
Run SQL assets in this order:
1. `sql/01_semantic_source_views.sql`
2. `sql/02_validation_baselines.sql`

Prepare semantic assets:
3. Open `dax/kpi-measures.dax`
4. Keep `kpi-validation-checklist.txt` available for parity checkpoints

## Exercises
1. Semantic model blueprint
- Ask AI to propose dimensions/facts and relationship cardinalities.
- Validate against real SQL grain.

2. DAX measure generation
- Generate measures for:
  - Availability
  - Performance
  - Quality
  - OEE
- Include filter context notes and shift boundary handling.

3. Partition and refresh strategy
- Ask AI for partitioning by event date and line.
- Design incremental refresh policy for high-volume telemetry.

4. Validation query parity
- Compare DAX results against SQL baseline queries from `sql/02_validation_baselines.sql`.

## How to perform the key steps
1. Execute `sql/01_semantic_source_views.sql` to ensure semantic source views are ready.
2. Execute `sql/02_validation_baselines.sql` and save baseline KPI outputs for comparison.
3. Use AI prompts to generate or refine measures in `dax/kpi-measures.dax`.
4. Validate DAX vs SQL baseline for selected machine and shift slices.
5. Document any parity differences, assumptions, and corrections in the validation checklist.
6. Finalize partition and incremental refresh strategy aligned to telemetry volume.

## Prompt Starters
- Prompt Starter #1: "Design an SSAS tabular model for IIoT telemetry with dimensions for machine, line, shift, and date."
- Prompt Starter #2: "Generate DAX measures for OEE, Availability, Performance, Quality with clear assumptions."
- Prompt Starter #3: "Propose partition and incremental refresh strategy for 24x7 telemetry ingestion."

## Prompt Playbook (when and how to fill)
1. Before Prompt Starter #1, fill section 1) Query Design Prompt for the semantic model layout task.
2. Before Prompt Starter #2, create another section 1) Query Design Prompt entry for DAX KPI generation assumptions.
3. Before Prompt Starter #3, fill section 6) Agent Prompt for partition and refresh planning.
4. In Validation Step, record SQL baseline comparison and parity status using outputs from `sql/02_validation_baselines.sql`.

## Deliverables
- SSAS model design spec
- DAX measure pack
- Partition and refresh strategy doc
- Validation evidence (DAX vs SQL parity)

## Validation
- DAX KPI outputs reconcile with SQL baseline at selected checkpoints.
- Time-intelligence and shift boundaries behave correctly.
- Refresh strategy meets expected freshness and runtime goals.
