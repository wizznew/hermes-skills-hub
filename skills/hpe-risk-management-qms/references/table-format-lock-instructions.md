# Table Format Lock Instructions - Learned from Session 2026-05-30

This document captures the exact table format requirements that were painfully established during the QMS audit session on 2026-05-30 after multiple failures.

## EXACT FORMAT REQUIREMENTS

### Structure
```
#XX — Risk Title
Risk description sentence. Owner: Team Name.

|                  | Existing                                 | Proposed                                                |
|------------------|------------------------------------------|---------------------------------------------------------|
| Risk Description | [exact text from Excel]                  | Same                                                    |
| Owner            | [exact text from Excel]                  | Same                                                    |
| Impact           | [exact value from Excel]                 | [proposed value]                                        |
| Likelihood       | [exact value from Excel]                 | [proposed value]                                        |
| Mitigation       | – or [existing text]                     | [new/updated text]                                      |
| Contingency      | [existing text]                          | [enhanced text]                                         |
| Risk Response    | – or [existing text]                     | In Treatment                                            |
```

### NON-NEGOTIABLE RULES
1. **SIDE-BY-SIDE ONLY** - Always 3 columns: (empty header) | Existing | Proposed
2. **ROW LABELS IN FIRST COLUMN** - Field names go in first column body
3. **NO VERTICAL FORMAT** - Never restructure as Field: Value pairs vertically
4. **NO EXTRA COLUMNS** - Only these three columns permitted
5. **NO EXTRA ROWS** - Only the standard 7 rows unless Excel columns demand otherwise
6. **COPY THE TEMPLATE EXACTLY** - When user shows example, replicate pixel-perfect
7. **NO "IMPROVEMENTS"** - Do not attempt to "make it cleaner" or "more readable"

### WHAT TRIGGERS THIS LESSON
- User frustration with vertical/key-value table formats
- Repeated corrections saying "formatnya jadi begini lagi, bolak balik salah-salah lagi"
- Explicit instruction to use the same format as Risk #19
- User stating "bisa gak sih kamu bikin risk 20 dalam format yang persis sama"

### ENFORCEMENT
If user shows a table format example, treat it as a LOCKED TEMPLATE. Deviating will result in explicit user correction and frustration.

This is not a suggestion - it is a hard constraint established through negative reinforcement.