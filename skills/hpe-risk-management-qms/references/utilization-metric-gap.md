# Utilization Metric Gap — Field Engineer Pre-Onsite Work

## Issue
Engineer utilization metrics in HPE ASM only count time **after arrival at customer site**.
Pre-onsite verification and preparation work (required by many mitigations) is NOT billable/utilization time.

## Examples of Uncounted Work
1. **DBD Verification & Confirmation**
   - Reading Dispatch/Diagnostic Data (DBD)
   - Confirming action plan with GS-Remote via CE Assist before departure
   - Verifying spare part availability/compatibility

2. **Technical Preparation**
   - Downloading/preparing image files for re-image tasks
   - Verifying firmware/software versions
   - Preparing USB/PXE boot media
   - Checking license keys/activation codes

3. **Safety/Access Preparation**
   - Confirming site access requirements (badge, escort, PPE)
   - Verifying work permits for hazardous areas
   - Checking environmental conditions (temperature, humidity limits)

## Typical Time Impact
- Simple verification: 5-15 minutes
- Image/software preparation: 20-45 minutes
- Complex setup (network config, RAID): 30-60+ minutes

## Behavioral Impact
Because utilization metrics exclude this work:
- Engineers who skip pre-onsite prep appear MORE productive (higher utilization %)
- Engineers who follow mitigation procedures appear LESS productive
- Creates perverse incentive to violate SOPs and just "show up" then figure it out onsite
- Audit findings may cite "process not followed" when engineer is actually responding to metric pressure

## Mitigation Strategies
1. **Track Pre-Onsite Time Separately**
   - Add "prep time" code in time-tracking system
   - Report as "quality overhead" or "readiness investment"

2. **Adjust Utilization Targets**
   - Baseline target accounts for average prep time per dispatch type
   - Different targets for different work categories (swap vs install vs re-image)

3. **Output-Based Metrics**
   - First-time-fix rate
   - SLA compliance %
   - Customer satisfaction score
   - Less reliance on input-based utilization

4. **Managerial Discretion**
   - Recognize that 85% utilization with 100% process compliance may be better than 95% utilization with 60% compliance
   - Use utilization as one metric among many, not the primary KPI

## Documentation for Auditors
When designing mitigation that requires pre-onsite work:
- Explicitly call out the utilization metric gap in discussion notes
- Show how mitigation improves actual outcomes (FTR, SLA, CSAT) even if utilization % dips
- Provide data: "After implementing verification step, utilization dropped from 92% to 87% but FTR increased from 78% to 94%"

## References
- Observed in Risk #7 (Wrong DBD) mitigation requiring CE Assist confirmation before dispatch
- Relevant to any risk where engineer must verify/prepare before site arrival
- Particularly acute for software/firmware tasks requiring file preparation