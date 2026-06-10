---
name: workshop1-ssas-semantic
description: 'Create and review SSAS tabular AI workshop content for IIoT/SCADA analytics. Use for semantic model design, DAX KPI measures, partitioning, and incremental refresh strategy in Workshop 4.'
argument-hint: 'Provide KPI list (OEE, availability, performance, quality), grain, and refresh constraints.'
user-invocable: true
---

# Workshop 4 SSAS Semantic Module

## Purpose
Provide a structured AI-first lab flow for SSAS tabular modeling in industrial dashboards and reporting.

## When to Use
- Designing SSAS tabular model layout.
- Generating DAX KPI measures.
- Planning partitions and incremental refresh.
- Validating semantic correctness and report behavior.

## Required Procedure
1. Prompt Copilot to propose model entities and relationships.
2. Generate DAX measures for core KPIs.
3. Validate measure correctness against SQL baseline queries.
4. Prompt Copilot for partitioning and refresh strategy.
5. Save reusable prompt templates.

## Mandatory Technical Coverage
- Fact/dimension mapping for telemetry, shifts, alarms, downtime.
- DAX for OEE, availability, performance, quality.
- Time-intelligence handling across shift boundaries.
- Partitioning and incremental refresh strategy.
- Validation queries for KPI parity.

## Required Outputs
- SSAS model design specification.
- DAX measure pack.
- Refresh and partition strategy.
- Validation evidence (KPI parity checks against SQL source).
