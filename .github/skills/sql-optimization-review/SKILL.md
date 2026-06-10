---
name: sql-optimization-review
description: 'Review and optimize T-SQL for IIoT/SCADA workloads. Use for execution plan analysis, CTE/window-function rewrites, index candidates, and indexed-view recommendations.'
argument-hint: 'Provide query text, execution symptoms, and expected SLA.'
user-invocable: true
---

# SQL Optimization Review

## Purpose
Provide consistent, repeatable optimization guidance for production SQL workflows.

## Procedure
1. Analyze query correctness and business-rule alignment.
2. Identify performance anti-patterns (non-sargable predicates, broad scans, scalar UDF hotspots).
3. Propose two rewrites: readability-first and performance-first.
4. Recommend index or indexed-view candidates with trade-offs.
5. Return validation plan (IO/time stats, plan shape, row parity).

## Required Output
- Findings by severity
- Rewritten query options
- Index/indexed-view recommendations
- Validation checklist
