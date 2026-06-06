# TABLE FORMAT SPECIFICATION (HARD RULE)

## Structure
Line 1: `#XX — Risk Title`  
Line 2: `Risk description sentence. Owner: Team Name.`  
Line 3: (blank)  
Line 4 onwards: Table with EXACT format below

## Table Format (COPY THIS EXACTLY)
|                  | Existing                                 | Proposed                                                |
|------------------|------------------------------------------|---------------------------------------------------------|
| Risk Description | [exact text from Excel]                  | Same                                                    |
| Owner            | [exact text from Excel]                  | Same                                                    |
| Impact           | [exact value from Excel]                 | [proposed value]                                        |
| Likelihood       | [exact value from Excel]                 | [proposed value]                                        |
| Mitigation       | – or [existing text]                     | [new/updated text]                                      |
| Contingency      | [existing text]                          | [enhanced text]                                         |
| Risk Response    | – or [existing text]                     | In Treatment                                            |

## Rules
- Column headers MUST be exactly `|                  | Existing                                 | Proposed                                                |`
- Row labels MUST be exactly as shown above (Risk Description, Owner, Impact, Likelihood, Mitigation, Contingency, Risk Response)
- Do NOT add extra rows (Date, Status, etc.) unless they exist in Excel
- Do NOT add narrative, bullets, or explanation before/after table
- If user requests "show detail only": keep same table format, leave Proposed column blank or mark "—"
- If updating Excel: apply changes EXACTLY as shown in Proposed column
- NEVER deviate from this format under any circumstance

## Examples of WRONG formats to AVOID:
- Adding extra columns or rows
- Using different column headers
- Adding narrative before/after table
- Changing order of rows
- Merging/splitting cells
- Using markdown formatting inside cells (bold, italics, etc.)
- Adding emojis or special characters