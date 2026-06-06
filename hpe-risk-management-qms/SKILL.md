---
name: qms-risk-register-update
description: Update QMS Risk Register Excel files based on discussion notes and auditor feedback.
---

## Workflow
0. **Terminology: use "HPE Operations" not "ASM".** ASM is a service brand, not an entity. All mitigation, contingency, and discussion text should refer to "HPE Operations" (or the specific team like GS-FD, GS-Remote, IPM, Global Logistic). Never use "ASM" as the acting entity.
1. **Read the risk row from Excel first.** Extract current values (Impact, Likelihood, existing Mitigation, existing Contingency, Status). Present an **Existing vs Proposed comparison table** so the user can clearly see what changes.

   **Table format rules (HARD RULE — never deviate):**
   - Use this EXACT format for every risk display. This format was locked by the user after repeated failures — ANY deviation is unacceptable.
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
   - **Line 1:** Risk title as heading: `#XX — Risk Title` (plain heading, NO bold `**`)
   - **Line 2:** Brief risk description + `. Owner: Team Name.` (single sentence)
   - **Line 3:** Blank
   - **Line 4 onwards:** Table with EXACT column headers `|                  | Existing                                 | Proposed                                                |`
   - **Column widths:** Use spacing to align columns (pad with spaces); do NOT use HTML or special formatting
   - Do NOT add narrative bullets, sub-sections, or explanatory paragraphs BEFORE or AFTER the table
   - Do NOT add extra rows (e.g., Date, Status) unless they are in the existing Excel columns
   - Do NOT change column order or merge rows
   - If user asks to show detail only (no proposals), still use the same table format but leave Proposed blank or mark "—"
   - **CRITICAL:** This is a SIDE-BY-SIDE table (3 columns: Field | Existing | Proposed). Do NOT restructure into vertical/key-value format under any circumstances. The user has explicitly rejected vertical format multiple times.
   - **CRITICAL:** Do NOT add extra columns like "Field" as a first column. The table headers MUST be exactly: empty header cell, "Existing", "Proposed". The row labels (Risk Description, Owner, etc.) go in the first column body rows.
   - **CRITICAL:** If the user shows you a sample table format, copy it EXACTLY. Do not "improve", "adjust", or "optimize" it.
2. **Understand operational context.** For risks involving human behavior, process adherence, or field-engineer workflow — ask the user to explain the actual operational flow before finalizing assessment. Example: "apakah engineer onsite juga melakukan diagnosis sebagai kelengkapan diagnosa yang dilakukan oleh DBD?"
   - **"Bagaimana menurutmu?" / "gimana pendapatmu" pattern**: When the user asks for your opinion, GIVE YOUR HONEST ASSESSMENT FIRST, then present the comparison table. Don't just repeat the risk statement — translate it into field reality. Then show the table and ask "Setuju?"
   - **"Coba tampilkan" / "coba jelaskan" / "tampilkan detail" pattern**: This is a READ-ONLY request. Display the raw Excel data clearly using the standard table format (with Proposed column left blank or marked "—"). Do NOT propose changes. Do NOT add suggestions. Only display what exists. If user wants a comparison table with proposals, they will ask for it explicitly.
   - **"Buat tabel" / "tolong buat tabel" pattern**: Build a single 3-column table (Field | Existing | Proposed). Include ALL relevant rows (Risk Description, Owner, Impact, Likelihood, Mitigation, Contingency, Status). Do NOT add narrative before or after. Just the table.
   - **Ambiguity check**: If the risk description is ambiguous (e.g., "mobile phone issue" — is it device failure or communication failure?), ASK the user to clarify before proposing mitigation. Do not assume.
   - **Hidden metric gaps**: For field-engineer risks, always ask whether pre-onsite preparation time is counted in utilization metrics. If not, flag this as a perverse incentive against following mitigation procedures.
3. **Draft discussion notes (.txt)** into the QMS Audit folder. Use this template:

**Important**: Only proceed to write the .txt file and update Excel after explicit user confirmation (e.g., 'ya setuju, update excel dan discussion notes').
   - **Risk Description** — 1-2 sentence summary
   - **Current State (Pre-Review)** — existing Impact/Likelihood/Level/Mitigation/Contingency in a table
   - **Key Changes Explained** — each change with rationale (Impact rise, Likelihood rise, new Mitigation, enhanced Contingency)
   - *** For behavioral/process risks, add a **Process Clarification** subsection explaining how the actual operational flow works (engineer workflow, dispatcher procedure, etc.) — this pre-empts auditor questions about competence and accountability.
   - **Auditor Q&A Preparation** — 8 standard question categories, each with crisp answer:
     1. Why assessment changed (Impact/Likelihood/Level rationale)
     2. What evidence proves the plan is operational (SOP, training records, monitoring logs)
     3. How effectiveness is measured (metrics, frequency, owner)
     4. Timeline for implementation (closure date, milestones)
     5. What if risk materializes before treatment completes (emergency escalation)
     6. What differentiates this risk from similar ones (overlap defense)
     7. Who is accountable (primary + secondary owner)
     8. How compliance to the process is monitored (audit trail, quarterly checks)
   - **Open Items for Team Review** — checkbox list
   See `references/auditor-qa-example.md` for worked examples from actual audit sessions.
4. **Handle overlapping risks explicitly.** If user identifies overlap (e.g., "apa bedanya dengan yang nomor 4"), offer three options:
   - (a) **Redefine scope** — narrow each risk to a unique domain (e.g., Risk #4 = system-down, Risk #6 = entry-error)
   - (b) **Merge** — absorb the smaller risk into the broader one and delete the duplicate
   - (c) **Document-only** — mark **red highlight** in discussion notes, keep Excel unchanged, explain differentiation in auditor Q&A. Use when risks are related but distinct enough to track separately.
   Default to (c) unless user explicitly prefers (a) or (b).
5. **Get explicit user confirmation before touching Excel. This is a hard boundary.**

   **❌ NEVER** update Excel, create .txt files, or write any file when user is still in discussion/exploration mode. Signals user is still discussing:
   - User asks questions about the risk
   - User gives operational context / shares process knowledge
   - User says "adjust dulu coba", "jelasin dulu maksudnya", "tunggu masih di X dulu"
   - User asks for your opinion first ("gimana menurutmu?", "apa maksudnya?")
   - User says "coba tampilkan" / "coba jelaskan" — this is DISCUSSION phase only, NOT approval to execute
   - User is still looking at, reading, or thinking about the table you just displayed

   **✅ ONLY** update after user gives explicit verbal confirmation AND explicitly mentions file actions (update/save/write), e.g.:
   - "ya setuju, update excel dan discussion notes"
   - "oke, langsung update"
   - "ya, update filenya"
   - "go ahead and update", "proceed with the update", "save it"

   **How to structure the gate:**
   Display the EXACT table format (see rule #1). Ask "Setuju?" or "Komentar?"
   **WAIT.** Do NOT proceed, add commentary, or move to next risk.
   Only after explicit "ya" + file action mention → proceed.
   
   **❌ NEVER jump to the next risk** without explicit instruction. Do NOT ask "Lanjut ke Risk #X?" — flagged as rushing.
   **❌ NEVER execute during discussion.** No exceptions. Violating this boundary will get called out.
   
   **Memory anchor:** User explicitly said "koq kenapa kamu langsung update excel? kan kita masih diskusi dan saya gak minta untuk update excelnya" — discussing ≠ confirming. Do not confuse user sharing context with permission to execute. User also said "kenapa langsung di update sih, emang saya udah bilang minta di update sebelumnya, saya kan cuma minta ditampilkan" — showing ≠ approving.
6. **Open the QMS Risk Register workbook** (path shown in notes).
7. **Identify the cells to update:**
   - **Impact** (col H), **Likelihood** (col I), **Level** (col J = H × I)
   - **Mitigation Plan** (col K)
   - **Contingency Plan** (col L)
   - **Risk Response Decision** (col P)
   - **Date for Closure** (col Q)
   - **Risk Status** (col R)
8. **Apply the new text.** If existing Contingency already has content, COMBINE old and new (prefix existing with "Existing: " then "Enhanced: " on new additions), never blindly overwrite. User may also choose to keep existing content unchanged and add only Mitigation — confirm before overwriting.
9. **Highlight edited cells** with light‑green fill (`#C6EFCE`, font `006100`) for visual tracking.
10. **Save the workbook.**
11. **Save discussion notes .txt** in the same QMS Audit folder for team review.

## Pitfalls
- **Permission denied** – the workbook is locked if Excel is open on Windows (especially OneDrive-synced files). Workaround: save to /tmp first, then user closes Excel, then copy back. NEVER attempt to overwrite while Excel has the file open.
- **Formatting loss** – keep original column widths and number formats; avoid pasting into merged cells.
- **Engineer workflow assumptions** – for risks involving field engineers or dispatchers, do NOT assume you know their process. Ask user to explain the real workflow first ("apakah engineer onsite melakukan diagnosis juga?"). Wrong assumption → wrong assessment → auditor will spot it.
- **Discussing risks while workbook is open** – user may be reviewing the same Excel. Run all updates via Python script, never ask user to type manually into Excel.
- **Pre-onsite preparation time NOT counted in utilization metrics** – When mitigation requires engineers to verify/prepare before onsite dispatch (check DBD, confirm with CE Assist, download image files, prepare USB/PXE), this 20–45 min of real work is NOT counted in the engineer's utilization clock (starts only at site arrival). This creates a perverse incentive to skip mitigation steps and just go to site blindly. Always flag this gap when designing mitigation for field-engineer risks. Note in discussion notes so management can discuss metric adjustment.
- **Discussing ≠ confirming** — User sharing operational context, asking questions, or debating options does NOT mean they want you to execute. If user says "tunggu", "ada hal yang mau saya tanyakan", "jelasin dulu", "adjust dulu", "gimana menurutmu", "coba tampilkan", "coba jelaskan", or asks clarification questions — you are in DISCUSSION phase. Stay there. Only update Excel after explicit "ya setuju / go ahead / update / proceed / oke lanjutkan" combined with explicit mention of file update/save. Violating this boundary will get called out.
- **Ownership confusion** – Different risks have different owners (IPM, GS-FD, GS-Remote, SubK Management, IT Operations). Always verify the risk owner before writing mitigation. Don't assume IPM owns everything. Only the actual risk owner should be tagged in the mitigation plan. See `references/risk-ownership-map.md`.
- **Wrong highlight color** – Default highlight is light-green (#C6EFCE). Use yellow (#FFFF00) only when user explicitly requests yellow. Don't assume yellow unless stated.

- **Ownership confusion** – Different risks have different owners (IPM, GS-FD, GS-Remote, SubK Management, IT Operations, Global Logistic). Always verify the risk owner before writing mitigation. Don't assume IPM owns everything. Only the actual risk owner should be tagged in the mitigation plan. See `references/risk-ownership-map.md`.
- **Impact-only risks (no root-cause control)** – Some risks are owned by external teams (e.g., Global Logistic) and HPE Operations only receives the impact. In these cases, HPE mitigation focuses on **impact protection**: buffer stock, SLA negotiation, escalation paths, proactive customer communication. Do NOT write mitigation that implies HPE controls the root cause (e.g., don't say "HPE will manage the courier" — instead say "HPE will escalate to Global Logistic and activate buffer stock").
- **Removing/consolidating risks** – User may want to remove a risk from the register if it's fully owned by another team and HPE has no control. Confirm before removing. If user says "ini bukan tanggung jawab kita," offer to either: (a) remove from register, (b) keep with "Accept/Transfer" status documenting HPE receives impact but doesn't own the root cause.


## References
- `references/discussion-notes.txt` – Session‑specific discussion transcript from risk #1 example.
- `references/auditor-qa-example.md` – Worked examples of standard auditor Q&A patterns for 8 question categories, with real answers from actual sessions.
- `references/utilization-metric-gap.md` – Explanation of why pre-onsite preparation time is not counted in engineer utilization metrics and how this creates perverse incentives against following mitigation procedures.
- `references/risk-ownership-map.md` – Risk ownership map across the QMS register: which team owns which risk type. Don't default to IPM — verify per risk.
- `references/table-format-lock-instructions.md` – Critical session-specific lockdown of the EXACT table format required by the user after multiple format failures. Treat as non-negotiable template.
- `scripts/excel-update.py` – Example script that loads the workbook, updates the designated cells, and applies a light‑green fill (hex `#C6EFCE`) to highlight changes.

## Templates
- `templates/excel-update-template.py` – Starter script skeleton for future updates (calls `update_excel_cells()` helper).

## Scripts
- `scripts/excel-update.py` – Ready‑to‑run script that performs the updates described above. It:
  - Opens the workbook read‑write.
  - Writes the new mitigation and contingency text with ✅ prefixes.
  - Highlights affected cells with a light‑green background.
  - Saves and prints a short summary.

## Example Output
```
Risk #1 updated successfully.
Mitigation: Maintain emergency contact database (already running). Define BCP Communication Protocol — who, channel, timing, template per customer tier. Maintain Golden Unit customer list & ensure currency.
Contingency: Golden Unit customer: Activate CSR via remote guidance (phone/email). No transportation dependency. Non‑Golden customer: Reschedule support. Provide ETA based on transportation recovery estimate. Proactive communication via defined protocol. Escalate to Top Management if SLA breach incurred on Tier 1 accounts.
Risk Response: Mitigate — reduce impact through tiered approach based on Golden Unit capability
Date Closure: To be determined
Risk Status: In Treatment
```

---

Use this umbrella skill whenever you need to refresh the Risk Register after a discussion. See `references/discussion-notes.txt` and `references/auditor-qa-example.md` for worked examples.