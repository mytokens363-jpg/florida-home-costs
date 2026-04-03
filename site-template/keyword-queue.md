# Keyword Queue

Format: `- STATUS | keyword | category | location`

STATUS values:
- PENDING     → not yet processed (pipeline will process these)
- IN_PROGRESS → currently being written (set by pipeline)
- PUBLISHED   → live on site
- QUARANTINED → failed max revisions, needs human review

---

## PENDING Keywords (Ready to Process)

- PENDING | cost to replace roof fort lauderdale 2026 | roofing | Fort Lauderdale
- PENDING | cost to repipe house florida 2026 | plumbing | Florida
- PENDING | cost to paint house exterior florida 2026 | exterior | Florida
- PENDING | cost to replace windows fort lauderdale 2026 | exterior | Fort Lauderdale

---

## Published Articles (7 Total)

| Date | Keyword | Category | Status |
|------|---------|----------|--------|
| 2026-04-02 | cost to replace roof in Florida 2026 | roofing | Live |
| 2026-04-02 | cost to install whole house generator florida 2026 | electrical | Live |
| 2026-04-02 | cost to install hurricane impact windows miami 2026 | hurricane-protection | Live |
| 2026-04-02 | cost to replace hvac system orlando 2026 | hvac | Live |
| 2026-04-02 | cost to remodel kitchen jacksonville 2026 | interior | Live |
| 2026-04-02 | cost to install solar panels tampa 2026 | major-systems | Live |
| 2026-04-02 | cost to install pool cage naples 2026 | pool | Live |

---

## Pipeline Status

Run `python3 night_shift.py` to process the PENDING keywords.
The dashboard at `pipeline-status.json` will update in real-time.
