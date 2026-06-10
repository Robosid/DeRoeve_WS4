# Tabular Model Specification

## Model Name
WorkshopScadaSemanticModel

## Fact Tables
- FactProduction (event-level or shift-aggregated production counts)
- FactDowntime (downtime events with planned/unplanned classification)
- FactAlarms (alarm events with severity and code)

## Dimensions
- DimDate
- DimShift
- DimLine
- DimMachine
- DimReasonCode

## Relationship Guidance
- DimMachine 1-* FactProduction/FactDowntime/FactAlarms
- DimLine 1-* DimMachine
- DimDate 1-* facts via EventDate key
- DimShift 1-* facts via ShiftKey derived from timestamp

## Grain Notes
- Production grain: machine-time bucket
- Downtime grain: event interval
- Alarm grain: event timestamp

## Governance
- Keep surrogate keys stable.
- Enforce deterministic shift-key derivation.
- Add data quality flags for late arrivals and missing dimensions.
