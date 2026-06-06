# Auditor Q&A — Worked Examples

Standard 8-question pattern with real answers from 2026 QMS audit sessions.
See also: Risk1-7_Discussion_Notes.txt files in the QMS Audit folder.

---

## Q1: Why assessment changed?
→ Impact/Likelihood/Level rationale

Example (Risk #5 — Staff Retention):
"On review, loss of an engineer covering a banking client has cascading effects:
SLA breach risk, customer relationship damage, knowledge gaps taking 3-6 months
to fill. Likelihood raised based on historical attrition data in the team."

Example (Risk #7 — Wrong DBD):
"For banking clients, every minute of onsite delay counts against SLA.
Wrong DBD causing engineer to wait can trigger penalty or audit finding."

---

## Q2: What evidence proves the plan is operational?
→ SOP, training records, monitoring logs

Example (Risk #4):
"(a) IT monitoring dashboard screenshots; (b) Manual case-logging template
available in shared repository; (c) Customer hotline number tested monthly;
(d) Training attendance records for dispatchers"

Example (Risk #5):
"(a) Compensation benchmarking report (HR); (b) Engagement survey results;
(c) 1:1 session logs; (d) Cross-training matrix showing min 2 engineers/account"

---

## Q3: How is effectiveness measured?
→ Metrics, frequency, owner

Example (Risk #4):
"Tracked via: (a) System uptime monitoring (IT, real-time); (b) Manual case
template usage count (Service Delivery Manager, monthly); (c) Customer
complaint rate related to system unavailability (Customer Service, quarterly)"

Example (Risk #7):
"(a) CE Assist usage rate per dispatch; (b) Engineer DBD confirmation records;
(c) Post-dispatch quality check by Service Delivery Manager; (d) Customer
feedback on first-time fix rate"

---

## Q4: Timeline for implementation?
→ Closure date, milestones

Standard answer pattern:
"Phase 1 (2 weeks): SOP finalized and signed off. Phase 2 (1 week): Training
session completed. Phase 3 (ongoing): Monthly quality audit. Target closure:
To be determined / [specific date]."

---

## Q5: What if risk materializes before treatment completes?
→ Emergency escalation path

Example (Risk #5 — Staff Retention):
"(a) Immediate notification to Account Manager & Service Delivery Manager;
(b) Escalate to regional/national management; (c) Activate buddy engineer
from adjacent account; (d) HPE HR emergency recruitment protocol"

Example (Risk #7 — Wrong DBD):
"(a) Engineer stops — CE Assist for updated action plan; (b) Backup spare
pool (Golden Unit) available for critical accounts; (c) Customer communication
per SLA protocol"

---

## Q6: What differentiates this risk from similar ones? (Overlap defense)
→ Clear scope boundary

Example (Risk #4 vs Risk #6):
"Risk #4 = infrastructure failure (system unavailable — 503, login error,
outage). Risk #6 = process failure (system available but entry process
breaks — wrong channel, miscategorization, duplicate). Two distinct risk
sources requiring different treatment approaches."

---

## Q7: Who is accountable?
→ Primary + secondary owner

Standard pattern:
"Service Delivery Manager (primary — SOP & training). Account Manager
(secondary — customer channel guidance). Both review monthly."

For field-engineer risks: "GS-Remote lead (primary) + Service Delivery
Manager (secondary — dispatch quality oversight)."

---

## Q8: How is compliance monitored?
→ Audit trail, quarterly checks

Example (Risk #7):
"(a) CE Assist ticket log (real-time); (b) Dispatch records with pre-onsite
check timestamp; (c) Engineer completion report includes verification step;
(d) Monthly quality audit of dispatch records"

Example (Risk #5):
"(a) 1:1 session frequency log (line manager, monthly); (b) Cross-training
matrix (supervisor, quarterly sign-off); (c) Retention rate YoY (HR);
(d) Engagement survey scores (annual)"

---

## Operational Context Questions (pre-assess phase)

For risks involving people/process, always ask the user first:

- "Apakah engineer onsite juga melakukan diagnosis sebagai kelengkapan
  diagnosa yang dilakukan oleh DBD?" — Risk #7
- "Apakah ada prosedur khusus untuk [task], atau engineer ikut instruksi
  mentah?" — General pattern
- "Apa yang seharusnya engineer lakukan sebelum/sesudah [event]?"
  — General pattern
- "Bagaimana metrik utilisasi dihitung untuk pre-onsite preparation?"
  — Hidden operational gaps

These questions ground the assessment in reality and produce auditor-ready
answers that match actual operations, not theoretical ideals.
