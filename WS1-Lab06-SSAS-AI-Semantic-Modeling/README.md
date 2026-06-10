# Lab 6: SSAS AI Semantic Modeling

## Objective
Use AI to design a production-relevant SSAS tabular semantic layer for IIoT/SCADA KPI analytics.

## Tools
- SSMS 22.7.0 (Analysis Services support)
- SSAS Tabular tooling
- Copilot (for model and DAX design)

## Inputs
- Fact telemetry and event data from prior labs
- KPI requirements: OEE, Availability, Performance, Quality

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

## Prompt Starters
- "Design an SSAS tabular model for IIoT telemetry with dimensions for machine, line, shift, and date."
- "Generate DAX measures for OEE, Availability, Performance, Quality with clear assumptions."
- "Propose partition and incremental refresh strategy for 24x7 telemetry ingestion."

## Deliverables
- SSAS model design spec
- DAX measure pack
- Partition and refresh strategy doc
- Validation evidence (DAX vs SQL parity)

## Validation
- DAX KPI outputs reconcile with SQL baseline at selected checkpoints.
- Time-intelligence and shift boundaries behave correctly.
- Refresh strategy meets expected freshness and runtime goals.
