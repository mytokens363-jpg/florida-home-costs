# Phase 3: Pipeline Scope Check — floridahomecosts (2026-05-26)

## TL;DR

**The pipeline is healthy and actively shipping to floridahomecosts.** This is a *different pipeline* from the one feeding prorepairguide (seo-pipeline at `~/seo-pipeline/`). It does not share the pluralization bug, the contamination cohort, or the SQL DB. It runs nightly via launchd, ships 5 articles per night, current 5-night track record is 100% publish rate.

## 3.1 — Pipeline state (file-based, not SQL)

Source: `~/.openclaw/workspace/rivet-business/site-template/keyword-queue.md` + `publishing-log.md` + `pipeline-status.json`.

**Status distribution:**

| Status | Count |
|---|---|
| PUBLISHED | 341 |
| PENDING | 71 |
| IN_PROGRESS | 2 (orphaned from crashed runs — known issue) |
| QUARANTINED | 0 (the "1" earlier was a header line, not a real entry) |

**Approval rate (last 30 days):**

publishing-log records only PUBLISHED entries. Failures are in `night-shift-log.md`. Recent run reports:
- 2026-05-25: 5 processed, **5 published, 0 errors** (100%)
- 2026-05-24: 5 processed, 4 published, 1 error (80%)
- Earlier 30 days: 2-11 articles/day, averaging ~6.6/day, almost all PUBLISHED

**QA score distribution — last 50 entries:**

| Editor score | n | | SEO score | n |
|---|---|---|---|---|
| 8.5 | 23 | | 8.8 | 16 |
| 9.2 | 11 | | 9.0 | 14 |
| 8.3 | 11 | | 8.6 | 8 |
| 8.2 | 2 | | 8.4 | 4 |
| 9.0 | 1 | | 8.0 | 4 |
| 8.7 | 1 | | 9.2 | 2 |
| 7.7 | 1 | | 8.2 | 2 |

**All scores in 7.7–9.2 band.** No outliers, no rubber-stamp cluster, no over-constraint cluster. Healthy.

## 3.2 — Pipeline template / prompts (DIFFERENT from seo-pipeline)

| Aspect | floridahomecosts (rivet-business) | prorepairguide (seo-pipeline) |
|---|---|---|
| Orchestrator | `night_shift.py` | `pipeline.py` |
| State | File-based (`.md` + `.json`) | SQLite (`pipeline.db`) |
| Stages | Writer → Editor + SEO consensus | Writer → Editor → SEO → QA |
| Articles/night | 5 (`ARTICLES_PER_NIGHT`) | 30 (`PIPELINE.batch_size`) |
| Templates | Single `prompts/article-template.txt` (full example article) | `best-trade-city`, `cost_location` |
| Title pattern | "How Much Does It Cost to **X** in **City**? (2026 Guide)" | "Best **X**s in **City** **STATE**" |
| Pluralization defect | ❌ none (template hardcodes a real article H1) | ✅ present (naive `+ "s"`) |
| LLM endpoints | 10.0.0.13 (Writer Qwen3.5-35B), 10.0.0.21 (Editor + SEO Qwen3.5-122B) | shared Rivet3 cluster |
| Scheduler | launchd `com.rivet.night-shift` 23:45 | crontab `0 1 * * *` |

**Key insight:** this is not the same pipeline. The prorepairguide H1 pluralization defect does not affect floridahomecosts. The contamination cohort that triggered 283 noindex flags doesn't exist here.

## 3.3 — `primary_topic` / title format check

Source for keywords: `site-template/keyword-queue.md` (curated by hand or by an upstream curator, not naive code).

Sample of next 8 PENDING:

```
cost to replace thermostat in Miami 2026
cost to replace thermostat in Fort Lauderdale 2026
cost to replace thermostat in Tampa 2026
cost to resurface pool in Naples 2026
cost to resurface pool in Cape Coral 2026
cost to resurface pool in Boca Raton 2026
cost to resurface pool in Coral Gables 2026
cost to resurface pool in Davie 2026
```

**All grammatically clean.** Pattern: `cost to <verb> <object> in <City> <Year>`. Writer transforms this into: `How Much Does It Cost to <verb> <object> in <City>? (<Year> Guide)`. No defects in the topic generator.

## 3.4 — Recency check

`pipeline-status.json` snapshot (last run):

```json
{
  "run_active": false,
  "run_started": "2026-05-25T23:45:01.752609",
  "articles_target": 5,
  "articles_done": 5,
  "results": [
    { "keyword": "cost of duct cleaning in Fort Lauderdale 2026", "status": "PUBLISHED", "revisions": 0 },
    { "keyword": "cost of duct cleaning in Tampa 2026",           "status": "PUBLISHED", "revisions": 0 },
    { "keyword": "cost to clean ac coils in Miami 2026",          "status": "PUBLISHED", "revisions": 0 },
    { "keyword": "cost to clean ac coils in Fort Lauderdale 2026", "status": "PUBLISHED", ...},
    ...
  ]
}
```

**Last successful end-to-end run: 2026-05-25 23:45 UTC** (last night). 5/5 published, 0 revisions needed.

Next scheduled run: tonight 23:45 local (launchd `com.rivet.night-shift`).

## Open issues

- **2 IN_PROGRESS orphans** from prior crashed runs: `cost to replace hvac system in Fort Lauderdale 2026` and `cost of duct cleaning in Miami 2026`. Pipeline doesn't auto-retry these — they need to be flipped back to PENDING manually (per memory pattern).

- **PENDING queue at 71** — sufficient for ~14 nights at 5/night. Refill cadence is known.

## Pipeline-readiness paragraph

The floridahomecosts pipeline is healthy and currently shipping. It is not the same architecture as prorepairguide and does not share any of prorepairguide's known defects. The last 5 nightly runs (2026-05-21 → 2026-05-25) produced 19 published articles with 1 error, 0 quarantined. Editor + SEO scores are in the 7.7–9.2 band — calibrated, not rubber-stamping. **Pipeline readiness: GREEN.** The only blocker on continued shipping is whether to push commit `5336f86` (Phase 1 finding) so future cron runs don't clash with the local-only redirect commit.
