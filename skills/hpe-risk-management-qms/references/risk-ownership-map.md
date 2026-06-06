## Risk Ownership Map
Different risks in the QMS register have different owners. Always verify before assigning mitigation.

| Risk Category | Owner | Notes |
|---|---|---|
| Installation design readiness | IPM / A&PS | Design gate, baseline config, SOP & checklist |
| Site readiness (DC infra) | IPM / PM | Facility readiness, project timeline |
| Customer cooperation / DBD logs | GS-Remote / Diagnostic Team | NOT IPM; remote diagnostic support |
| Field engineer skill gap | GS-FD | Skill matrix, OJT, certification |
| Remote engineer skill gap | GS-Remote | Remote diagnostic tools, knowledge base |
| SubK (sub-contractor) unavailability | GS-FD / SubK Management | SLA enforcement, backup list |
| FSM system downtime | GS-FD / IT Operations | Monitoring, manual fallback, BCP testing |
| System outage (platform) | IT Operations / Platform Team | Platform availability, BCP |
| Data entry / logging | Operations / Data Governance | Process adherence, audit trail |

**Rule:** Don't default to IPM. Only tag IPM when the risk explicitly involves installation/design/project scope. Case-by-case from user instruction.