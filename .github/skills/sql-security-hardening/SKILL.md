---
name: sql-security-hardening
description: 'Perform SQL security hardening for industrial systems. Use for SQL injection checks, unsafe dynamic SQL remediation, credential leakage detection, and secure procedure rewrites.'
argument-hint: 'Provide SQL object text and threat focus areas.'
user-invocable: true
---

# SQL Security Hardening

## Purpose
Apply repeatable SQL security checks and safe rewrites for production SCADA/IIoT systems.

## Procedure
1. Detect SQL injection vectors and unsafe dynamic SQL.
2. Detect hardcoded credentials and insecure connection patterns.
3. Rewrite with parameterized SQL and strict input validation.
4. Propose least-privilege execution and auditing updates.
5. Return verification plan (negative tests and safe-input tests).

## Required Output
- Vulnerability findings and risk level
- Patched SQL fragments
- Test cases for exploit prevention
- Deployment checklist
